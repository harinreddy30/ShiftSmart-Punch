import Foundation

struct ScheduleResponse: Codable {
    let schedule: [Shift]  // ✅ Ensure this matches API response
}
