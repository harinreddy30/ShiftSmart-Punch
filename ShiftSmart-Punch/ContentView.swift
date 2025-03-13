import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()  // Create AuthViewModel instance
    
    var body: some View {
        // Check if the user is authenticated
        if authViewModel.isAuthenticated {
            // Show ScheduleView if authenticated
            ScheduleView()
                .environmentObject(authViewModel)  // Pass the AuthViewModel to ScheduleView
        } else {
            // Show LoginView if not authenticated
            LoginView()
                .environmentObject(authViewModel)  // Pass the AuthViewModel to LoginView
        }
    }
}

#Preview {
    ContentView()
}
