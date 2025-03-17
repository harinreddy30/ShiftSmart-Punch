import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case unauthorized
}

class APIService {
    static let shared = APIService()
    private let baseURL = "http://127.0.0.1:3000/api/v1" // BaseURL
        
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



}
