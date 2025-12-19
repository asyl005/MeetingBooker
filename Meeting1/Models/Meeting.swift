import Foundation

// MeetingStatus
enum MeetingStatus: String, Codable {
    case pending = "Күтуде"
    case accepted = "Бекітілді"
    case declined = "Бас тартылды"
}

struct Meeting: Identifiable, Codable {
    let id: UUID
    var teacherName: String
    var parentName: String
    var studentName: String
    var date: Date
    var notes: String?
    var status: MeetingStatus
    
    init(id: UUID = UUID(), teacherName: String, parentName: String, studentName: String, date: Date, notes: String? = nil, status: MeetingStatus = .pending) {
        self.id = id
        self.teacherName = teacherName
        self.parentName = parentName
        self.studentName = studentName
        self.date = date
        self.notes = notes
        self.status = status
    }
}
