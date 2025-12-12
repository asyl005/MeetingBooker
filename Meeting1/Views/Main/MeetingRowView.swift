import SwiftUI

struct MeetingRowView: View {
    let meeting: Meeting
    @StateObject private var timer = CountdownTimer()
    
    // Мәртебе түсі
    var statusColor: Color {
        switch meeting.status {
        case .pending: return .orange
        case .accepted: return .green
        case .declined: return .red
        }
    }
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0)
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("\(meeting.teacherName) • \(meeting.studentName)")
                    .font(.headline)
                    .foregroundColor(.black)
                
                Text(meeting.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                // Мәртебесін көрсету
                Text(meeting.status.rawValue)
                    .font(.caption2).bold()
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(statusColor.opacity(0.15))
                    .foregroundColor(statusColor)
                    .cornerRadius(4)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("Қалды").font(.caption2).foregroundColor(.secondary)
                
                Text(timer.timeRemaining)
                    .font(.subheadline)
                    .bold()
                    .monospacedDigit()
                    .foregroundColor(primaryColor)
            }
            .onAppear { timer.startCountdown(to: meeting.date) }
            .onDisappear { timer.stop() }
        }
        .padding(.vertical, 6)
    }
}
