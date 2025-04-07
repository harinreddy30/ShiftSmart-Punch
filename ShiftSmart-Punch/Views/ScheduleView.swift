import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @State private var selectedDate = Date()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showingProfile = false

    init(viewModel: ScheduleViewModel) {
        self.viewModel = viewModel
    }
    struct TimesheetView: View {
        var body: some View {
            Text("Timesheet will be shown here.")
                .font(.title2)
                .foregroundColor(.gray)
                .padding()
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Modern Navigation Bar
            HStack {
                Text("Schedule")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                
                Spacer()
                
                HStack(spacing: 20) {
                    NavigationLink(destination: TimesheetView()) {
                        Image(systemName: "calendar")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                    
                    Button(action: {
                        authViewModel.logout()
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 20))
                            .foregroundColor(.red)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)

            // Week Selector with modern design
            HStack {
                Button(action: { moveWeek(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text(formattedWeekRange)
                    .font(.headline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(20)
                
                Spacer()
                
                Button(action: { moveWeek(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding()

            // Weekdays Row with modern design
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(getWeekDays(), id: \.self) { day in
                        VStack(spacing: 8) {
                            Text(day, format: .dateTime.weekday(.short))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(day, format: .dateTime.day())
                                .font(.headline)
                                .frame(width: 36, height: 36)
                                .background(isSelectedDay(day) ? Color.blue : Color.clear)
                                .foregroundColor(isSelectedDay(day) ? .white : .primary)
                                .clipShape(Circle())
                        }
                        .onTapGesture {
                            withAnimation {
                                selectedDate = day
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 10)

            // Shifts List with modern design
            ScrollView {
                if filteredShifts.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                        
                        Text("No shifts scheduled")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Text("You have no shifts scheduled for this day")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    VStack(spacing: 15) {
                        ForEach(filteredShifts) { shift in
                            NavigationLink(destination: ShiftDetailView(shift: shift)) {
                                ShiftCardView(shift: shift)
                                    .transition(.scale)
                            }
                        }
                    }
                    .padding()
                }
            }

            // Week summary with modern design
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                Text("Week total:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(totalWeeklyHours) hrs")
                    .font(.headline)
                    .foregroundColor(.blue)
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -2)
        }
        .navigationBarHidden(true)
        .onAppear {
            print("🔹 ScheduleView Appeared - Fetching Shifts")
            viewModel.fetchShifts()
        }
    }

    // Helper functions remain the same
    var formattedWeekRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let start = formatter.string(from: startOfWeek)
        let end = formatter.string(from: endOfWeek)
        return "\(start) - \(end)"
    }

    private func getWeekDays() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Start week on Monday
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
        return (0...6).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    private func moveWeek(by weeks: Int) {
        withAnimation {
            if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: selectedDate) {
                selectedDate = newDate
            }
        }
    }

    private func isSelectedDay(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }

    private var startOfWeek: Date {
        let calendar = Calendar.current
        return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
    }
    
    private var endOfWeek: Date {
        Calendar.current.date(byAdding: .day, value: 6, to: startOfWeek)!
    }

    var filteredShifts: [Shift] {
        viewModel.shifts.filter { shift in
            guard let shiftDate = shift.dateObject else { return false }
            return isSelectedDay(shiftDate)
        }
    }

    var totalWeeklyHours: Int {
        viewModel.shifts
            .filter { isDateInCurrentWeek($0.dateObject) }
            .reduce(0) { total, shift in
                if let shiftDetails = shift.shiftId {
                    return total + shiftDetails.totalHours
                }
                return total + shift.totalHours
            }
    }

    private func isDateInCurrentWeek(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .weekOfYear)
    }
}
