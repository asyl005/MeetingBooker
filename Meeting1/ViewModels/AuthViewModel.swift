import Foundation
import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {
    @Published var currentUser: User? = nil
    @Published var users: [User] = []
    
    private let usersKey = "MB_users_v1"
    private let currentUserKey = "MB_currentUser_v1"
    
    init() {
        loadUsers()
        loadCurrentUser()
        prepopulateDemoUsersIfNeeded()
    }
    
    private func prepopulateDemoUsersIfNeeded() {
        if users.isEmpty {
            let demoTeacher = User(fullName: "Сабира Асқарқызы", email: "sabira@school.kz", password: "123", role: .teacher)
            
            let childrenForParent = [
                Child(name: "Әлихан Мұратұлы", className: "5 'А'"),
                Child(name: "Аяжан Мұратқызы", className: "9 'Б'")
            ]
            let demoParent = User(fullName: "Мұрат Жанұзақов", email: "parent@mail.kz", password: "123", role: .parent, children: childrenForParent)
            
            users.append(demoTeacher)
            users.append(demoParent)
            Database.shared.save(users, key: usersKey)
        }
    }
    
    func register(fullName: String, email: String, password: String, role: UserRole) -> Bool {
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty else { return false }
        guard users.first(where: { $0.email.lowercased() == email.lowercased() }) == nil else { return false }
        
        let user: User
        if role == .parent {
            user = User(fullName: fullName, email: email, password: password, role: role, children: [Child(name: "Жаңа Бала", className: "1 'Ә' сынып")])
        } else {
            user = User(fullName: fullName, email: email, password: password, role: role)
        }
        
        users.append(user)
        saveUsers()
        
        _ = login(email: email, password: password)
        return true
    }
    
    func login(email: String, password: String) -> Bool {
        if let u = users.first(where: { $0.email.lowercased() == email.lowercased() && $0.password == password }) {
            currentUser = u
            saveCurrentUser()
            return true
        }
        return false
    }
    
    func logout() {
        currentUser = nil
        Database.shared.save(nil as User?, key: currentUserKey)
    }
    private func saveUsers() {
        Database.shared.save(users, key: usersKey)
    }
    private func loadUsers() {
        users = Database.shared.load([User].self, key: usersKey) ?? []
    }
    private func saveCurrentUser() {
        Database.shared.save(currentUser, key: currentUserKey)
    }
    private func loadCurrentUser() {
        currentUser = Database.shared.load(User.self, key: currentUserKey)
    }
}
