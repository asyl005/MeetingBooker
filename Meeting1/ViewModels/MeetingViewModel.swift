import Foundation
import SwiftUI
import Combine

final class MeetingViewModel: ObservableObject {
    @Published var meetings: [Meeting] = []
    @Published var teachers: [TeacherModel] = []
    
    private let meetingsKey = "MB_meetings_v1"
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadMeetings()
        loadDemoTeachersIfNeeded()
    }
    
    // 'Incorrect argument label' қатесін жою үшін:
    func createMeeting(teacher: String, parent: String, student: String, date: Date, notes: String?) {
        // Meeting init-тегі жаңа init-ті қолданамыз.
        let m = Meeting(teacherName: teacher, parentName: parent, studentName: student, date: date, notes: notes, status: .pending)
        meetings.append(m)
        saveMeetings()
    }
    
    // ... (Қалған функциялар өзгеріссіз)
    func updateMeeting(_ meeting: Meeting) {
        if let idx = meetings.firstIndex(where: { $0.id == meeting.id }) {
            meetings[idx] = meeting
            saveMeetings()
        }
    }
    
    func getAvailableSlots(for teacherName: String) -> [String] {
        return teachers.first(where: { $0.name == teacherName })?.availableSlots ?? ["Бос уақыттары жоқ"]
    }
    
    private func loadDemoTeachersIfNeeded() {
        if teachers.isEmpty {
            teachers = [
                TeacherModel(name: "Сабира Асқарқызы", subject: "Математика", availableSlots: ["Дс: 15:00-16:00", "Ср: 16:30-17:30"]),
                TeacherModel(name: "Асыл", subject: "Физика", availableSlots: ["Вт: 14:00-15:00"]),
                TeacherModel(name: "Оразгуль", subject: "Ағылшын", availableSlots: ["Пс: 11:00-12:00"])
            ]
        }
    }
    
    func saveMeetings() {
        Database.shared.save(meetings, key: meetingsKey)
    }
    private func loadMeetings() {
        meetings = Database.shared.load([Meeting].self, key: meetingsKey) ?? []
    }
}
