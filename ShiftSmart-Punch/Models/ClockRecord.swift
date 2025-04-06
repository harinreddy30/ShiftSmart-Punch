import Foundation

struct ClockRecord: Codable, Identifiable, Equatable {
    let id: String
    let scheduleId: String
    let clockInTime: Date
    var clockOutTime: Date?
    let createdAt: Date
    let updatedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case scheduleId
        case clockInTime
        case clockOutTime
        case createdAt
        case updatedAt
    }
    
    static func == (lhs: ClockRecord, rhs: ClockRecord) -> Bool {
        return lhs.id == rhs.id &&
               lhs.scheduleId == rhs.scheduleId &&
               lhs.clockInTime == rhs.clockInTime &&
               lhs.clockOutTime == rhs.clockOutTime &&
               lhs.createdAt == rhs.createdAt &&
               lhs.updatedAt == rhs.updatedAt
    }
}

struct ClockInRequest: Codable {
    let scheduleId: String
    let clockInTime: Date
}

struct ClockOutRequest: Codable {
    let clockOutTime: Date
} 