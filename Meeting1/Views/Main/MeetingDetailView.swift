import SwiftUI

struct MeetingDetailView: View {
    @EnvironmentObject var meetingVM: MeetingViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var meeting: Meeting
    @StateObject private var timer = CountdownTimer()
    
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0)
    
    var isTeacher: Bool {
        authVM.currentUser?.role == .teacher && authVM.currentUser?.fullName == meeting.teacherName
    }

    var body: some View {
        VStack(spacing: 20) {
            
            MeetingStatusBanner(status: meeting.status, primaryColor: primaryColor)
                
            // MARK: - Чат түймесі
            NavigationLink(destination: ChatView(meetingID: meeting.id, receiverName: isTeacher ? meeting.parentName : meeting.teacherName)) {
                HStack {
                    Image(systemName: "message.fill")
                    Text("Мұғаліммен / Ата-анамен сөйлесу")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(primaryColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            .padding(.top, 10)
            
            Form {
                Section("Жиналыс ақпараты") {
                    HStack { Text("Мұғалім: **\(meeting.teacherName)**") }
                    HStack { Text("Ата-ана: **\(meeting.parentName)**") }
                    HStack { Text("Баласы: **\(meeting.studentName)**") }
                    HStack { Text("Уақыты: **\(meeting.date, style: .date) \(meeting.date, style: .time)**") }
                }
                
                Section("Жиналысқа дейінгі уақыт") {
                    VStack {
                        Text("Қалған уақыт").font(.caption).foregroundColor(.secondary)
                        Text(timer.timeRemaining).font(.title).bold().monospacedDigit().foregroundColor(primaryColor)
                    }
                    .frame(maxWidth: .infinity)
                }

                if let notes = meeting.notes, !notes.isEmpty {
                    Section("Ескертулер") { Text(notes).foregroundColor(.gray) }
                }
            }
            .listStyle(.grouped)
            
            // MARK: - Мұғалімге арналған Әрекеттер
            if isTeacher && meeting.status == .pending {
                HStack(spacing: 15) {
                    Button("Бас тарту") { updateStatus(newStatus: .declined) }
                        .buttonStyle(.borderedProminent).tint(.red)
                    
                    Button("Қабылдау") { updateStatus(newStatus: .accepted) }
                        .buttonStyle(.borderedProminent).tint(.green)
                }
                .padding(.bottom)
            }
            
            Spacer()
        }
        .navigationTitle("Жиналыс Мәліметі")
        .onAppear { timer.startCountdown(to: meeting.date) }
        .onDisappear { timer.stop() }
    }
    
    func updateStatus(newStatus: MeetingStatus) {
        var updatedMeeting = meeting
        updatedMeeting.status = newStatus
        meetingVM.updateMeeting(updatedMeeting)
        meeting = updatedMeeting
    }
}

struct MeetingStatusBanner: View {
    let status: MeetingStatus
    let primaryColor: Color
    
    var statusColor: Color {
        switch status {
        case .pending: return .orange
        case .accepted: return .green
        case .declined: return .red
        }
    }
    
    var body: some View {
        Text("Мәртебесі: \(status.rawValue)")
            .font(.headline).bold()
            .padding(.vertical, 8).padding(.horizontal, 20)
            .background(statusColor.opacity(0.1)).foregroundColor(statusColor).cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(statusColor, lineWidth: 1)).padding(.top, 10)
    }
}
