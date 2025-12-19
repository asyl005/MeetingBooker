import SwiftUI

struct ParentMeetingsView: View {
    @EnvironmentObject var meetingVM: MeetingViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @State private var showCreate = false
    
    var parentMeetings: [Meeting] {
        meetingVM.meetings.filter { $0.parentName == authVM.currentUser?.fullName }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let children = authVM.currentUser?.children, !children.isEmpty {
                VStack(alignment: .leading) {
                    Text("Менің балаларым").font(.headline).padding(.top, 5)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            
                            // MARK: - Бірінші бала (Тікелей мәтінмен қосылған)
                            VStack(alignment: .leading) {
                                Text("Арман Әділханұлы").bold()
                                Text("1 'Ә' сынып").font(.caption).foregroundColor(.secondary)
                            }
                            .padding(10)
                            .background(Color.gray.opacity(0.1)).cornerRadius(8)
                            
                            // MARK: - Екінші бала (Тікелей мәтінмен қосылған)
                            VStack(alignment: .leading) {
                                Text("Айша Әділханқызы").bold()
                                Text("5 'Б' сынып").font(.caption).foregroundColor(.secondary)
                            }
                            .padding(10)
                            .background(Color.gray.opacity(0.1)).cornerRadius(8)
                            
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // MARK: - Жиналыс сұраныстары
            HStack {
                Text("Менің сұраныстарым").font(.headline).padding(.top, 10)
                Spacer()
                Button(action: { showCreate.toggle() }) {
                    Label("Жаңа жиналыс", systemImage: "plus")
                }
            }
            .padding(.horizontal)
            
            List {
                ForEach(parentMeetings) { m in
                    NavigationLink(destination: MeetingDetailView(meeting: m)) {
                        MeetingRowView(meeting: m)
                    }
                }
                .onDelete { idx in
                    // ... (өшіру логикасы өзгеріссіз)
                    let filtered = meetingVM.meetings.enumerated().filter { $0.element.parentName == authVM.currentUser?.fullName }
                    let toRemove = idx.map { filtered[$0].offset }
                    meetingVM.meetings.remove(atOffsets: IndexSet(toRemove))
                    meetingVM.saveMeetings()
                }
            }
        }
        .sheet(isPresented: $showCreate) {
            CreateMeetingView()
                .environmentObject(meetingVM)
                .environmentObject(authVM)
        }
    }
}
