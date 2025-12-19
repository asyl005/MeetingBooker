import Foundation

enum MessageRole: String, Codable {
    case parent = "Ата-ана"
    case teacher = "Мұғалім"
}

struct Message: Identifiable, Codable {
    let id: UUID
    let senderRole: MessageRole
    let content: String
    let timestamp: Date
    
    init(id: UUID = UUID(), senderRole: MessageRole, content: String, timestamp: Date) {
        self.id = id
        self.senderRole = senderRole
        self.content = content
        self.timestamp = timestamp
    }
}

struct Chat: Identifiable, Codable {
    let id: UUID // Meeting ID-мен бірдей
    var messages: [Message] = []
    
    init(id: UUID, messages: [Message] = []) {
        self.id = id
        self.messages = messages
    }
}
