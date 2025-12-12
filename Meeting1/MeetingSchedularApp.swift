import SwiftUI

@main
struct MeetingSchedulerApp: App {
    @StateObject private var authVM = AuthViewModel()
    @StateObject private var meetingVM = MeetingViewModel()
    @StateObject private var chatVM = ChatViewModel() // Chat ViewModel-ді қосу
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authVM)
                .environmentObject(meetingVM)
                .environmentObject(chatVM) // Chat ViewModel-ді тіркеу
        }
    }
}
