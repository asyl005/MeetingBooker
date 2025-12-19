import SwiftUI

struct ChatView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var chatVM: ChatViewModel
    
    let meetingID: UUID
    let receiverName: String
    
    @State private var messageText: String = ""
    
    let primaryColor = Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0)

    var chat: Chat {
        chatVM.getChat(for: meetingID)
    }
    
    var currentUserRole: MessageRole {
        authVM.currentUser?.role == .parent ? .parent : .teacher
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List(chat.messages) { message in
                    MessageRow(message: message, isCurrentUser: message.senderRole == currentUserRole)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .id(message.id)
                }
                .listStyle(.plain)
                .onChange(of: chat.messages.count) {
                    scrollToBottom(proxy: proxy)
                }
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }
            }
            
            // MARK: - Хабарлама жіберу Input
            HStack {
                TextField("Хабарламаңызды жазыңыз...", text: $messageText, axis: .vertical)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(primaryColor)
                }
                .padding(.horizontal, 5)
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding([.horizontal, .bottom])
        }
        .navigationTitle("\(receiverName) чаты")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        chatVM.sendMessage(to: meetingID, senderRole: currentUserRole, content: messageText)
        messageText = ""
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastMessage = chat.messages.last else { return }
        withAnimation {
            proxy.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
}

//хабарламаны көрсету
struct MessageRow: View {
    let message: Message
    let isCurrentUser: Bool
    
    var body: some View {
        HStack {
            if isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading) {
                Text(message.content)
                    .padding(10)
                    .background(isCurrentUser ? Color(red: 0.2, green: 0.6, blue: 0.9, opacity: 1.0) : Color.gray.opacity(0.2))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .cornerRadius(15, corners: isCurrentUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight])
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !isCurrentUser {
                Spacer()
            }
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
