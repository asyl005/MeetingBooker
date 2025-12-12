import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationView {
            if authVM.currentUser == nil {
                LoginView()
            } else {
                HomeView()
            }
        }
    }
}

