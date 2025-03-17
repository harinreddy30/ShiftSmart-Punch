import Foundation

class ScheduleViewModel: ObservableObject {
    @Published var shifts: [Shift] = []
    @Published var isLoading = false
    private var authToken: String?

    init(authToken: String? = nil) {
        self.authToken = authToken
    }

    func fetchShifts() {
        isLoading = true
        Task {
            do {
                let response = try await APIService.shared.fetchShifts(authToken: authToken ?? KeychainHelper.shared.get("jwtToken"))
                DispatchQueue.main.async {
                    self.shifts = response.schedule
                    self.isLoading = false
                    print("✅ Successfully updated shifts: \(self.shifts.count) shifts loaded.")
                }
            } catch {
                DispatchQueue.main.async {
                    self.isLoading = false
                    print("❌ Error Fetching Shifts: \(error)")
                }
            }
        }
    }
}
