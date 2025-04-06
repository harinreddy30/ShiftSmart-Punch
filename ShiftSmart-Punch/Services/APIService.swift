import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case unauthorized
    case serverError
}

class APIService {
    static let shared = APIService()
    private let baseURL = "http://127.0.0.1:3000/api/v1"
        
    private init() {}

    // MARK: - Login Function
    func login(email: String, password: String, completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/login") else {
            completion(.failure(.invalidURL))
            return
        }
        
        let body: [String: String] = ["email": email, "password": password]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 401 {
                    // Explicit handling of unauthorized errors
                    completion(.failure(.unauthorized))
                } else {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                // Save JWT Token securely in Keychain
                KeychainHelper.shared.save(decodedResponse.token, key: "jwtToken")
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }


    // MARK: - Fetch Shifts (Authenticated)
    
    func fetchShifts(authToken: String?) async throws -> ScheduleResponse {
        guard let url = URL(string: "\(baseURL)/schedule/employee/schedule") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token = authToken ?? KeychainHelper.shared.get("jwtToken") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        if let jsonString = String(data: data, encoding: .utf8) {
            print("🔹 Raw JSON Response: \(jsonString)")
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }

        do {
            return try JSONDecoder().decode(ScheduleResponse.self, from: data)
        } catch {
            print("❌ JSON Decoding Error: \(error)")
            throw APIError.decodingError(error)
        }
    }

    func clockIn(scheduleId: String) async throws -> ClockRecord {
        let url = "\(baseURL)/clockIn/clockin"
        let request = ClockInRequest(scheduleId: scheduleId, clockInTime: Date())
        
        guard let urlObj = URL(string: url) else {
            print("❌ Invalid URL: \(url)")
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: urlObj)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = KeychainHelper.shared.get("jwtToken") else {
            print("❌ No token found for clock in")
            throw APIError.unauthorized
        }
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            urlRequest.httpBody = try encoder.encode(request)
            print("✅ Request body encoded: \(String(data: urlRequest.httpBody!, encoding: .utf8) ?? "")")
        } catch {
            print("❌ Failed to encode request: \(error)")
            throw APIError.invalidResponse
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                throw APIError.invalidResponse
            }
            
            print("🔹 Clock in response status: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("🔹 Clock in response body: \(responseString)")
            }
            
            if httpResponse.statusCode == 401 {
                print("❌ Unauthorized request")
                throw APIError.unauthorized
            }
            
            guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
                print("❌ Server error with status: \(httpResponse.statusCode)")
                throw APIError.serverError
            }
            
            let decoder = JSONDecoder()
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            decoder.dateDecodingStrategy = .custom { decoder in
                let container = try decoder.singleValueContainer()
                let dateString = try container.decode(String.self)
                
                if let date = formatter.date(from: dateString) {
                    return date
                }
                
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
            
            do {
                let record = try decoder.decode(ClockRecord.self, from: data)
                print("✅ Successfully clocked in")
                return record
            } catch {
                print("❌ Failed to decode response: \(error)")
                throw APIError.decodingError(error)
            }
        } catch {
            print("❌ Network error: \(error)")
            throw APIError.networkError(error)
        }
    }

    func clockOut(clockRecordId: String) async throws -> ClockRecord {
        let url = "\(baseURL)/clockIn/clockout/\(clockRecordId)"
        let request = ClockOutRequest(clockOutTime: Date())
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let token = KeychainHelper.shared.get("jwtToken") else {
            throw APIError.unauthorized
        }
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        urlRequest.httpBody = try encoder.encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        return try decoder.decode(ClockRecord.self, from: data)
    }

    func getClockRecords(scheduleId: String) async throws -> [ClockRecord] {
        let url = "\(baseURL)/clockIn/employee/\(scheduleId)"
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = "GET"
        
        guard let token = KeychainHelper.shared.get("jwtToken") else {
            throw APIError.unauthorized
        }
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        if httpResponse.statusCode == 401 {
            throw APIError.unauthorized
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError
        }
        
        let decoder = JSONDecoder()
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            if let date = formatter.date(from: dateString) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
        }
        return try decoder.decode([ClockRecord].self, from: data)
    }

}
