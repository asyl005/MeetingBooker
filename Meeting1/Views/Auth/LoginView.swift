import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var errorText: String? = nil
    
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0)
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("MeetingBooker")
                .font(.largeTitle).bold()
                .foregroundColor(primaryColor) // Логотиптің түсі
                .padding(.bottom, 30)
            
            VStack(spacing: 16) {
                TextField("Электрондық пошта (Email)", text: $email)
                    .textFieldStyle(.plain) // Дизайнды жақсарту үшін .plain қолданамыз
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                
                SecureField("Құпия сөз (Password)", text: $password)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(10)
            }
            
            if let e = errorText {
                Text(e).foregroundColor(.red).font(.footnote).padding(.horizontal)
            }
            
            // MARK: - Кіру Батырмасы
            Button("Кіру") {
                if authVM.login(email: email, password: password) {
                    // Табысты кіру
                } else {
                    errorText = "Қате: Email немесе құпия сөз дұрыс емес"
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(primaryColor) // Ашық көк фон
            .foregroundColor(.white)
            .font(.headline)
            .cornerRadius(10)
            .padding(.top, 10)
            
            // MARK: - Тіркелу Батырмасы
            Button("Тіркелу") {
                showRegister = true
            }
            .foregroundColor(primaryColor) // Ашық көк мәтін
            
            .sheet(isPresented: $showRegister) {
                RegisterView()
                    .environmentObject(authVM)
            }
            
            Spacer()
        }
        .padding(25)
    }
}
