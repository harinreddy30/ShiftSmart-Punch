import Foundation

class AuthViewModel: ObservableObject {
    @Published var user: User?
    
    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        APIService.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    KeychainHelper.shared.save(response.token, key: "jwtToken")
                    self.user = response.user
                    completion(true, "")
                case .failure(let error):
                    completion(false, "Login failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
