import Foundation

// MeetingStatus (Жиналыс мәртебесі)
enum MeetingStatus: String, Codable {
    case pending = "Күтуде"
    case accepted = "Бекітілді"
    case declined = "Бас тартылды"
}

struct Meeting: Identifiable, Codable {
    // Codable Warning-ті жою үшін, 'id' сияқты тұрақты мәндерге бастапқы мән бергенде декодтауды қажет етпеу үшін,
    // егер олар init-те орнатылмаса, оларды 'let' ретінде қалдырамыз.
    let id: UUID // 'let' кодын сақтаймыз
    var teacherName: String
    var parentName: String
    var studentName: String
    var date: Date
    var notes: String?
    var status: MeetingStatus // Init-те мәні беріледі
    
    // Жаңа инициализаторды қосу (Тек қана қажетті өрістерді инициализациялау)
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
