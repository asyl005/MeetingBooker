import Foundation
import Combine
import SwiftUI

final class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    
    private let chatsKey = "MB_chats_v1"
    
    init() {
        loadChats()
    }
    
    func getChat(for meetingID: UUID) -> Chat {
        if let chat = chats.first(where: { $0.id == meetingID }) {
            return chat
        }
        let newChat = Chat(id: meetingID)
        chats.append(newChat)
        saveChats()
        return newChat
    }
    
    func sendMessage(to meetingID: UUID, senderRole: MessageRole, content: String) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        if let index = chats.firstIndex(where: { $0.id == meetingID }) {
            let newMessage = Message(senderRole: senderRole, content: content, timestamp: Date())
            chats[index].messages.append(newMessage)
            saveChats()
        } else {
            var newChat = Chat(id: meetingID)
            let newMessage = Message(senderRole: senderRole, content: content, timestamp: Date())
            newChat.messages.append(newMessage)
            chats.append(newChat)
            saveChats()
        }
    }
    
    func saveChats() {
        Database.shared.save(chats, key: chatsKey)
    }
    
    private func loadChats() {
        chats = Database.shared.load([Chat].self, key: chatsKey) ?? []
    }
}
