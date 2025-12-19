import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0)
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(authVM.currentUser?.fullName ?? "")
                        .font(.title2).bold()
                        .foregroundColor(.primary)
                    
                    // UserRole.rawValue арқылы қазақша атауды аламыз
                    Text("Рөл: \(authVM.currentUser?.role.rawValue ?? "Белгісіз")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                
                Button("Шығу") {
                    authVM.logout()
                }
                .buttonStyle(.bordered)
                .tint(.red)
            }
            .padding(.horizontal)
            .padding(.top, 10)
            
            if authVM.currentUser?.role == .parent {
                ParentMeetingsView()
            } else {
                TeacherMeetingsView()
            }
            
            Spacer()
        }
        .navigationTitle("Басты бет")
        .padding(.horizontal, 0) 
    }
}
