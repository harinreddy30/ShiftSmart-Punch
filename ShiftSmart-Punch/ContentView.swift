import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var scheduleViewModel = ScheduleViewModel()

    var body: some View {
        if authViewModel.isAuthenticated {
            ScheduleView(viewModel: scheduleViewModel)
                .environmentObject(authViewModel)
        } else {
            LoginView()
                .environmentObject(authViewModel)
        }
    }
}
