import Foundation

class DateRangeManager: ObservableObject {
    private let calendar = Calendar.current
    @Published private(set) var startDate: Date
    @Published private(set) var endDate: Date
    
    init() {
        // Initialize with default values first
        self.startDate = Date()
        self.endDate = Date()
        
        // Then set the actual dates
        let components = DateComponents(year: 2024, month: 2, day: 10)
        if let initialDate = calendar.date(from: components) {
            self.startDate = initialDate
            self.endDate = calendar.date(byAdding: .day, value: 13, to: initialDate) ?? initialDate
        }
    }
    
    func getDatesInRange() -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dates
    }
    
    func getDateRangeText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
    }
    
    func previousWeek() {
        startDate = calendar.date(byAdding: .day, value: -14, to: startDate)!
        endDate = calendar.date(byAdding: .day, value: -14, to: endDate)!
    }
    
    func nextWeek() {
        startDate = calendar.date(byAdding: .day, value: 14, to: startDate)!
        endDate = calendar.date(byAdding: .day, value: 14, to: endDate)!
    }
    
    func moveToToday() {
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysToSubtract = weekday - calendar.firstWeekday
        
        startDate = calendar.date(byAdding: .day, value: -daysToSubtract, to: today)!
        endDate = calendar.date(byAdding: .day, value: 13, to: startDate)!
    }
    
    func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        let dayNum = calendar.component(.day, from: date)
        let suffix = getDaySuffix(dayNum)
        return "\(formatter.string(from: date))\(suffix)"
    }
    
    private func getDaySuffix(_ day: Int) -> String {
        switch day {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
} 