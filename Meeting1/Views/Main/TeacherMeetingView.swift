import SwiftUI

struct TeacherMeetingsView: View {
    @EnvironmentObject var meetingVM: MeetingViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    var teacherFullName: String {
        authVM.currentUser?.fullName ?? ""
    }
    
    // Мұғалімге жіберілген, күтуде тұрған сұраныстар
    var pendingRequests: [Meeting] {
        meetingVM.meetings.filter { $0.teacherName == teacherFullName && $0.status == .pending }
    }
    
    // Бекітілген (алдағы) жиналыстар
    var acceptedMeetings: [Meeting] {
        meetingVM.meetings.filter { $0.teacherName == teacherFullName && $0.status == .accepted }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: - Күтудегі Сұраныстар
            Text("Күтудегі сұраныстар (\(pendingRequests.count))")
                .font(.headline).padding(.horizontal)
                .padding(.top, 10)
            
            if pendingRequests.isEmpty {
                Text("Жаңа сұраныстар жоқ").foregroundColor(.gray).padding(.horizontal)
            } else {
                List {
                    ForEach(pendingRequests) { m in
                        // MeetingDetailView ішінде Accept/Decline түймелері көрінеді
                        NavigationLink(destination: MeetingDetailView(meeting: m)) {
                            MeetingRowView(meeting: m)
                        }
                    }
                }
                .frame(height: CGFloat(min(pendingRequests.count * 60 + 50, 250))) // Максималды биіктік
            }
            
            Divider().padding(.horizontal)

            // MARK: - Алдағы Бекітілген Жиналыстар
            Text("Бекітілген жиналыстар (\(acceptedMeetings.count))")
                .font(.headline).padding(.horizontal)
                .padding(.top, 10)
            
            if acceptedMeetings.isEmpty {
                Text("Алдағы жиналыстар жоқ").foregroundColor(.gray).padding(.horizontal)
            } else {
                List {
                    ForEach(acceptedMeetings) { m in
                        NavigationLink(destination: MeetingDetailView(meeting: m)) {
                            MeetingRowView(meeting: m)
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}
