import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    @ObservedObject var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("ShiftSmart")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                if showError {
                    Text("Invalid username or password")
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button(action: loginUser) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationDestination(isPresented: $isLoggedIn) {
                if let token = KeychainHelper.shared.get("jwtToken") {
                    ScheduleView(viewModel: ScheduleViewModel(authToken: token))  // ✅ Pass token to ScheduleViewModel
                } else {
                    Text("Error: No token found")
                }
            }

        }
    }
    
    private func loginUser() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in all fields."
            showError = true
            return
        }
        
        authViewModel.login(email: email, password: password) { success, message in
            DispatchQueue.main.async {
                if success {
                    isLoggedIn = true
                } else {
                    errorMessage = message ?? "Login failed. Please try again."
                    showError = true
                }
            }
        }
    }
}
