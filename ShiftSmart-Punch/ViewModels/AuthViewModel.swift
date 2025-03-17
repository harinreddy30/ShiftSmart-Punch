import Foundation

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var user: User?

    init() {
        logout()  // ✅ Force logout on app launch
    }

    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        APIService.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    KeychainHelper.shared.save(response.token, key: "jwtToken")  // ✅ Save token after login
                    self.user = response.user
                    self.isAuthenticated = true
                    print("✅ Login successful, token saved")
                    completion(true, nil)
                case .failure(let error):
                    print("❌ Login Error: \(error.localizedDescription)")
                    self.isAuthenticated = false
                    completion(false, "Login failed. Please try again.")
                }
            }
        }
    }

    func logout() {
        KeychainHelper.shared.delete("jwtToken")  // ✅ Always remove token on app restart
        self.user = nil
        self.isAuthenticated = false
        print("✅ User logged out, token deleted")
    }
}
