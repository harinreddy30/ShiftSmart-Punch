import SwiftUI

struct ScheduleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedDate = Date()
    @State private var shifts: [Shift] = [
        Shift(
            id: "shift1",
            location: "Big Carrot",
            date: Date(),
            startTime: Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 15, minute: 0, second: 0, of: Date())!,
            clockInTime: nil,
            clockOutTime: nil
        ),
        Shift(
            id: "shift2",
            location: "No Frills - Damiano",
            date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            startTime: Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date())!,
            endTime: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
            clockInTime: nil,
            clockOutTime: nil
        )
    ]
    
    @EnvironmentObject var authViewModel: AuthViewModel // AuthViewModel for managing authentication state
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.red)
                }
                
                Text("GTA")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 15) {
                    Image(systemName: "calendar")
                        .foregroundColor(.red)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.red)
                    Image(systemName: "gearshape")
                        .foregroundColor(.red)
                }
            }
            .padding()
            
            // Logout Button (Moved to the top)
            Button(action: {
                logout()
            }) {
                Text("Logout")
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .padding(.top)

            // Calendar Strip
            CalendarStripView(selectedDate: $selectedDate)
            
            // Shifts List
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(filteredShifts) { shift in
                        NavigationLink(destination: ClockInView(shift: shift)) {
                            ShiftCardView(shift: shift)
                        }
                    }
                    
                    // Week Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Week summary Feb 10 - Feb 16 • 5 shifts")
                            .font(.headline)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
    }
    
    var filteredShifts: [Shift] {
        shifts.filter { Calendar.current.isDate($0.date, equalTo: selectedDate, toGranularity: .day) }
    }
    
    private func logout() {
        // Call the logout function in AuthViewModel
        authViewModel.logout()
        
        // Navigate back to the Login screen
        dismiss() // This dismisses the current view (ScheduleView)
    }
}

struct ShiftCardView: View {
    let shift: Shift
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Plainclothes Loss Prevention")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "building.2")
                    Text(shift.location)
                }
                .foregroundColor(.gray)
                
                Text("\(shift.startTime.formatted(date: .omitted, time: .shortened)) - \(shift.endTime.formatted(date: .omitted, time: .shortened))")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("HR")
                .padding(8)
                .background(Circle().fill(Color.gray.opacity(0.3)))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    NavigationView {
        ScheduleView()
            .environmentObject(AuthViewModel()) // Don't forget to inject the environment object
    }
}
