import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

class APIService {
    static let shared = APIService()
    private let baseURL = "YOUR_VERCEL_API_URL" // Replace with your Vercel API URL
    
    private init() {}
    
    // MARK: - Shifts
    func fetchShifts() async throws -> [Shift] {
        guard let url = URL(string: "\(baseURL)/shifts") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        do {
            let shifts = try JSONDecoder().decode([Shift].self, from: data)
            return shifts
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    func clockIn(shiftId: String) async throws {
        guard let url = URL(string: "\(baseURL)/shifts/\(shiftId)/clock-in") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
    }
    
    func clockOut(shiftId: String) async throws {
        guard let url = URL(string: "\(baseURL)/shifts/\(shiftId)/clock-out") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
    }
} 