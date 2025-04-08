import Foundation

class ClockViewModel: ObservableObject {
    @Published var currentClockRecord: ClockRecord?
    @Published var isClockingIn = false
    @Published var isClockingOut = false
    @Published var error: String?
    @Published var workTime: TimeInterval = 0
    @Published var shiftNote: String = ""

    private var timer: Timer?
    private let apiService: APIService

    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
    }

    func clockIn(scheduleId: String) {
        isClockingIn = true
        error = nil
        print("🔹 Attempting to clock in for schedule: \(scheduleId)")

        Task {
            do {
                let record = try await apiService.clockIn(scheduleId: scheduleId)
                DispatchQueue.main.async {
                    self.currentClockRecord = record
                    self.isClockingIn = false
                    self.startTimer(from: record.clockInTime)
                    print("✅ Successfully clocked in and started timer")
                }
            } catch {
                DispatchQueue.main.async {
                    self.isClockingIn = false
                    self.error = "Failed to clock in. \(error.localizedDescription)"
                    print("❌ Clock in error: \(error)")
                }
            }
        }
    }

    func clockOut() {
        guard let recordId = currentClockRecord?.id else { return }
        isClockingOut = true
        error = nil
        print("🔹 Attempting to clock out for record: \(recordId)")

        Task {
            do {
                let record = try await apiService.clockOut(clockRecordId: recordId)
                DispatchQueue.main.async {
                    self.stopTimer()
                    self.currentClockRecord = nil
                    self.updateWorkTime(from: record.clockInTime, to: record.clockOutTime)
                    self.isClockingOut = false
                    print("✅ Successfully clocked out and calculated time")
                }
            } catch {
                DispatchQueue.main.async {
                    self.isClockingOut = false
                    self.error = "Failed to clock out. \(error.localizedDescription)"
                    print("❌ Clock out error: \(error)")
                }
            }
        }
    }

    func startTimer(from clockInTime: Date) {
        stopTimer() // Reset any existing timer

        workTime = Date().timeIntervalSince(clockInTime)

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.workTime = Date().timeIntervalSince(clockInTime)
        }

        RunLoop.main.add(timer!, forMode: .common)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func formatTime(_ timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    func updateWorkTime(from clockIn: Date, to clockOut: Date?) {
        let outDate = clockOut ?? Date()
        var duration = outDate.timeIntervalSince(clockIn)
        if duration < 0 { duration += 86400 } // handles overnight shifts
        workTime = duration
    }

    deinit {
        stopTimer()
    }
}
