import Foundation

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?
    
    // Store user data if needed
    @Published var user: User?
    
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        APIService.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    // Save token securely in Keychain
                    KeychainHelper.shared.save(response.token, key: "jwtToken")
                    // Save user data if needed
                    self.user = response.user
                    
                    self.isAuthenticated = true
                    completion(true, nil)
                case .failure(let error):
                    print("Login Error: \(error)") // Debugging line
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    completion(false, self.errorMessage)
                }
            }
        }
    }
    
    func logout() {
        // Delete JWT token from Keychain
        KeychainHelper.shared.delete("jwtToken")
        
        // Clear user data
        self.user = nil
        
        // Set authentication status to false
        self.isAuthenticated = false
    }
}
