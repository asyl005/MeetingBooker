import SwiftUI

struct TeacherMeetingsView: View {
    @EnvironmentObject var meetingVM: MeetingViewModel
    @EnvironmentObject var authVM: AuthViewModel
    
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0)
    
    var teacherFullName: String {
        authVM.currentUser?.fullName ?? ""
    }
    
    var pendingRequests: [Meeting] {
        meetingVM.meetings.filter { $0.teacherName == teacherFullName && $0.status == .pending }
    }
    var acceptedMeetings: [Meeting] {
        meetingVM.meetings
            .filter { $0.teacherName == teacherFullName && $0.status == .accepted && $0.date > Date() }
            .sorted(by: { $0.date < $1.date })
    }
    
    private var mockPendingRequests: [Meeting] {
        let date20Dec = createDate(day: 20, month: 12, year: 2025, hour: 14, minute: 0) // 20 желтоқсан, 14:00
        let date21Dec = createDate(day: 21, month: 12, year: 2025, hour: 16, minute: 30) // 21 желтоқсан, 16:30
        
        return [
            Meeting(teacherName: teacherFullName, parentName: "Айбек Сағындықұлы", studentName: "Жансая Айбекқызы", date: date20Dec!, notes: "Үлгерім мәселесі", status: .pending),
            Meeting(teacherName: teacherFullName, parentName: "Динара Қайратқызы", studentName: "Әлішер Динарұлы", date: date21Dec!, notes: "Қосымша сабақ", status: .pending)
        ]
    }
    
    private var mockAcceptedMeetings: [Meeting] {
        let date20Dec_accepted = createDate(day: 20, month: 12, year: 2025, hour: 10, minute: 0) // 20 желтоқсан, 10:00
        let date21Dec_accepted = createDate(day: 21, month: 12, year: 2025, hour: 11, minute: 30) // 21 желтоқсан, 11:30
        let date22Dec_accepted = createDate(day: 22, month: 12, year: 2025, hour: 15, minute: 0) // 22 желтоқсан, 15:00

        return [
            Meeting(teacherName: teacherFullName, parentName: "Мұрат Жанұзақов", studentName: "Әлихан Мұратұлы", date: date20Dec_accepted!, notes: "Тарих сабағы", status: .accepted),
            Meeting(teacherName: teacherFullName, parentName: "Гүлжан Асқарқызы", studentName: "Ерлан Ғалымұлы", date: date21Dec_accepted!, notes: "Тәрбие сағаты", status: .accepted),
            Meeting(teacherName: teacherFullName, parentName: "Серік Ахметұлы", studentName: "Айғаным Серікқызы", date: date22Dec_accepted!, notes: "Емтихан дайындығы", status: .accepted)
        ]
    }
    
    private func createDate(day: Int, month: Int, year: Int, hour: Int, minute: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        return Calendar.current.date(from: components)
    }
    
    var displayPending: [Meeting] {
        pendingRequests.isEmpty ? mockPendingRequests : pendingRequests
    }
    
    var displayAccepted: [Meeting] {
        acceptedMeetings.isEmpty ? mockAcceptedMeetings : acceptedMeetings
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Күтудегі сұраныстар (\(displayPending.count))")
                .font(.title2).bold().padding(.horizontal)
                .padding(.top, 10)
            
            List {
                ForEach(displayPending) { m in
                    if pendingRequests.isEmpty {
                        MockPendingRow(meeting: m, primaryColor: primaryColor)
                    } else {
                        NavigationLink(destination: MeetingDetailView(meeting: m)) {
                            MeetingRowView(meeting: m)
                        }
                    }
                }
            }
            .frame(height: CGFloat(displayPending.count * 60 + 50))
            .listStyle(.plain)
            
            
            Divider().padding(.horizontal)

            Text("Бекітілген жиналыстар (\(displayAccepted.count))")
                .font(.title2).bold().padding(.horizontal)
                .padding(.top, 10)
            
            List {
                ForEach(displayAccepted) { m in
                    NavigationLink(destination: MeetingDetailView(meeting: m)) {
                        MeetingRowView(meeting: m)
                    }
                }
            }
            .listStyle(.plain)
            .frame(height: CGFloat(displayAccepted.count * 60 + 20))
            
            Spacer()
        }
    }
}

struct MockPendingRow: View {
    let meeting: Meeting
    let primaryColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(meeting.parentName) (Ата-ана) арқылы сұраныс")
                    .font(.headline)
                    .foregroundColor(primaryColor)
                
                Text("\(meeting.date, style: .date) сағат \(meeting.date, style: .time)")
                    .font(.subheadline)
                
                Text("Баласы: \(meeting.studentName)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(spacing: 5) {
                Button("Қабылдау") {
                  
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .controlSize(.small)

                Button("Бас тарту") {
                   
                }
                .buttonStyle(.bordered)
                .tint(.red)
                .controlSize(.small)
            }
        }
        .padding(.vertical, 5)
    }
}
