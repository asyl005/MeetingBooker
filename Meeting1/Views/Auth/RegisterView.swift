import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var role: UserRole = .parent
    @State private var errorText: String? = nil
    
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0)
    
    var body: some View {
        NavigationView {
            Form {
                Section("Негізгі ақпарат") {
                    TextField("Толық аты-жөні", text: $fullName)
                    TextField("Электрондық пошта (Email)", text: $email).autocapitalization(.none)
                    SecureField("Құпия сөз", text: $password)
                }
                
                Section("Рөлді таңдау") {
                    Picker("Рөл", selection: $role) {
                        
                        Text(UserRole.parent.rawValue).tag(UserRole.parent)
                        Text(UserRole.teacher.rawValue).tag(UserRole.teacher)
                    }
                    .pickerStyle(.segmented)
                }
                
                if let e = errorText {
                    Text(e).foregroundColor(.red)
                }
            }
            .navigationTitle("Тіркелу")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Тіркелу") {
                        let ok = authVM.register(fullName: fullName, email: email, password: password, role: role)
                        if ok {
                            dismiss()
                        } else {
                            errorText = "Тіркелу сәтсіз аяқталды (Барлық өрісті толтырыңыз немесе Email қолданылған)"
                        }
                    }
                    .foregroundColor(primaryColor) // Көк түс
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Бас тарту") { dismiss() }
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
