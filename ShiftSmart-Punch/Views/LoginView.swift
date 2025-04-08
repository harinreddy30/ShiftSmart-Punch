import SwiftUI

// View Page for Login
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError = false
    @State private var errorMessage = ""
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
                    Text(errorMessage)
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
                    showError = false
                } else {
                    errorMessage = message ?? "Login failed. Please try again."
                    showError = true
                }
            }
        }
    }
}
