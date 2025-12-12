import Foundation

struct TeacherModel: Identifiable, Codable {
    // Codable Warning-ті жою үшін id-ді init-те орнатамыз немесе
    // Codable Warnings-ті жою үшін барлық 'let' өрістерін 'var' етіп өзгертеміз.
    // Бірақ бұл жағдайда id-ді let қалдырып, init-те береміз.
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
