import Foundation

// Child (Бала) моделі
struct Child: Identifiable, Codable {
    let id: UUID
    var name: String
    var className: String
    
    init(id: UUID = UUID(), name: String, className: String) {
        self.id = id
        self.name = name
        self.className = className
    }
}

// UserRole (Қолданушы рөлі)
enum UserRole: String, Codable {
    case parent = "Ата-ана"
    case teacher = "Мұғалім"
}

struct User: Identifiable, Codable {
    let id: UUID
    var fullName: String
    var email: String
    var password: String
    var role: UserRole
    var children: [Child] = []
    
    // Init-ті толықтыру
    init(id: UUID = UUID(), fullName: String, email: String, password: String, role: UserRole, children: [Child] = []) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.password = password
        self.role = role
        self.children = children
    }
}
