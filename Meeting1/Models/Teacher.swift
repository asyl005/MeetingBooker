import Foundation

struct TeacherModel: Identifiable, Codable {
    let id: UUID
    var name: String
    var subject: String
    var availableSlots: [String] = []
    
    init(id: UUID = UUID(), name: String, subject: String, availableSlots: [String] = []) {
        self.id = id
        self.name = name
        self.subject = subject
        self.availableSlots = availableSlots
    }
}
