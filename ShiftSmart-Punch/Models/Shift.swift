import Foundation

struct Shift: Codable, Identifiable {
    let id: String  // ✅ "_id" is a string in JSON
    let userId: User
    let shiftId: ShiftDetails
    let date: String  // ✅ Change from `Double` to `String`
    let day: String
    let totalHours: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userId
        case shiftId
        case date
        case day
        case totalHours
    }
    
    var dateObject: Date? {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withFullDate]
            return formatter.date(from: date)
        }
}

struct ShiftDetails: Codable {
    let id: String
    let position: String
    let site: SiteDetails
    let jobDescription: String
    let startTime: String
    let endTime: String
    let totalHours: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case position
        case site
        case jobDescription
        case startTime
        case endTime
        case totalHours
    }
}

struct SiteDetails: Codable {
    let id: String
    let siteId: Int
    let name: String
    let location: LocationDetails

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case siteId
        case name
        case location
    }
}

struct LocationDetails: Codable {
    let address: String
    let coordinates: [Double]
}
