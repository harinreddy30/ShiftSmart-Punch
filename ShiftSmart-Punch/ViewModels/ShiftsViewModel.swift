import Foundation

@MainActor
class ShiftsViewModel: ObservableObject {
    @Published var shifts: [Shift] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let apiService = APIService.shared
    
    func fetchShifts() {
        isLoading = true
        error = nil
        
        Task {
            do {
                let fetchedShifts = try await apiService.fetchShifts()
                await MainActor.run {
                    self.shifts = fetchedShifts
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func clockIn(shiftId: String) {
        Task {
            do {
                try await apiService.clockIn(shiftId: shiftId)
                await fetchShifts()
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    func clockOut(shiftId: String) {
        Task {
            do {
                try await apiService.clockOut(shiftId: shiftId)
                await fetchShifts()
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    // Helper methods for TimesheetView
    func getShiftsForDate(_ date: Date) -> [Shift] {
        let calendar = Calendar.current
        return shifts.filter { shift in
            calendar.isDate(shift.date, inSameDayAs: date)
        }
    }
    
    func getTotalHoursForDate(_ date: Date) -> String {
        let dateShifts = getShiftsForDate(date)
        let totalSeconds = dateShifts.reduce(0) { $0 + $1.duration }
        let hours = Int(totalSeconds / 3600)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        return String(format: "%d:%02d", hours, minutes)
    }
} 