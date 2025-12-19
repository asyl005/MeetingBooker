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
            Spacer()
            
    
            VStack(spacing: 10) {
                Text("MeetingBooker")
                    .font(.largeTitle).bold()
                    .foregroundColor(primaryColor)
                
                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding(.bottom, 20)
            
            
            VStack(spacing: 16) {
                TextField("Электрондық пошта (Email)", text: $email)
                    .textFieldStyle(.plain)
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
                Text(e)
                    .foregroundColor(.red)
                    .font(.footnote)
                    .padding(.horizontal)
            }
            
            // MARK: - Кіру Батырмасы
            Button(action: {
                if authVM.login(email: email, password: password) {
                   
                } else {
                    errorText = "Қате: Email немесе құпия сөз дұрыс емес"
                }
            }) {
                Text("Кіру")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryColor)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
            
            // MARK: - Тіркелу Батырмасы
            Button("Тіркелу") {
                showRegister = true
            }
            .foregroundColor(primaryColor)
            
            Spacer()
        }
        .padding(25)
        .sheet(isPresented: $showRegister) {
            RegisterView()
                .environmentObject(authVM)
        }
    }
}
