import Foundation

struct Shift: Identifiable, Codable {
    let id: String
    let location: String
    let date: Date
    let startTime: Date
    let endTime: Date
    let clockInTime: Date?
    let clockOutTime: Date?
    
    init(id: String = UUID().uuidString, // Default id to UUID string
         location: String,
         date: Date,
         startTime: Date,
         endTime: Date,
         clockInTime: Date? = nil,
         clockOutTime: Date? = nil) {
        self.id = id
        self.location = location
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.clockInTime = clockInTime
        self.clockOutTime = clockOutTime
    }
    
    var duration: TimeInterval {
        if let clockIn = clockInTime, let clockOut = clockOutTime {
            return clockOut.timeIntervalSince(clockIn)
        }
        return endTime.timeIntervalSince(startTime)
    }
    
    // Add initializer for preview/testing
    static func preview() -> Shift {
        Shift(
            id: UUID().uuidString, // Convert UUID to String
            location: "8814 Big Carrot",
            date: Date(),
            startTime: Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!,
            clockInTime: nil,
            clockOutTime: nil
        )
    }
} 