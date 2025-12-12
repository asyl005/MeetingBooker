import SwiftUI

struct CreateMeetingView: View {
    @EnvironmentObject var meetingVM: MeetingViewModel
    @EnvironmentObject var authVM: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var teacherName = ""
    @State private var studentName = ""
    @State private var date = Date().addingTimeInterval(60*60)
    @State private var notes = ""
    
    // Таңдалған мұғалімнің бос уақыттарын алу
    var selectedTeacherSlots: [String] {
        meetingVM.getAvailableSlots(for: teacherName)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Мұғалімді таңдау") {
                    if !meetingVM.teachers.isEmpty {
                        Picker("Мұғалім", selection: $teacherName) {
                            ForEach(meetingVM.teachers) { t in
                                Text("\(t.name) — \(t.subject)").tag(t.name)
                            }
                        }
                        .onAppear {
                            if teacherName.isEmpty {
                                teacherName = meetingVM.teachers.first?.name ?? ""
                            }
                        }
                    } else {
                        TextField("Мұғалім аты", text: $teacherName)
                    }
                }
                
                // Мұғалімнің бос уақытын көрсету
                Section("Мұғалімнің бос кестесі") {
                    if selectedTeacherSlots.contains("Бос уақыттары жоқ") {
                        Text("Мұғалімнің бос уақыттары тіркелмеген.").foregroundColor(.red)
                    } else {
                        ForEach(selectedTeacherSlots, id: \.self) { slot in
                            Text(slot)
                        }
                    }
                }
                
                Section("Бала және Уақыт") {
                    TextField("Бала аты", text: $studentName)
                    DatePicker("Күні және уақыты", selection: $date)
                }
                Section("Ескертулер") {
                    TextField("Қосымша ескертулер", text: $notes)
                }
            }
            .navigationTitle("Жаңа жиналыс")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сақтау") {
                        let parentName = authVM.currentUser?.fullName ?? "Белгісіз Ата-ана"
                        meetingVM.createMeeting(teacher: teacherName, parent: parentName, student: studentName, date: date, notes: notes.isEmpty ? nil : notes)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Бас тарту") { dismiss() }
                }
            }
        }
    }
}
