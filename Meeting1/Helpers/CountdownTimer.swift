import Foundation
import Combine
import SwiftUI

final class CountdownTimer: ObservableObject {
    @Published var timeRemaining: String = "--:--:--"
    private var timer: Timer?
    private var targetDate: Date?

    func startCountdown(to date: Date) {
        targetDate = date
        timer?.invalidate()
        updateOnce()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateOnce()
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func updateOnce() {
        guard let target = targetDate else {
            timeRemaining = "--:--:--"
            return
        }
        let diff = Int(target.timeIntervalSinceNow)
        if diff <= 0 {
            timeRemaining = "Started"
            stop()
            return
        }
        let hours = diff / 3600
        let minutes = (diff % 3600) / 60
        let seconds = diff % 60
        timeRemaining = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    deinit {
        stop()
    }
}
