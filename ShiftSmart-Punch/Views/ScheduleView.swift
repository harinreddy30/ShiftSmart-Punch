import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel: ScheduleViewModel
    @State private var selectedDate = Date()

    var body: some View {
        VStack(spacing: 10) {
            // ✅ Fixed Top Navigation Bar
            ZStack {
                HStack {
                    Button(action: { /* Handle back action */ }) {
                        Image(systemName: "chevron.left").foregroundColor(.red)
                    }
                    Spacer()
                    Text("GTA")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    HStack(spacing: 15) {
                        Image(systemName: "calendar").foregroundColor(.red)
                        Image(systemName: "magnifyingglass").foregroundColor(.red)
                        Image(systemName: "gearshape").foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 50) // ✅ Prevent shifting

            // ✅ Week Selector with Arrows
            HStack {
                Button(action: { moveWeek(by: -1) }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                Spacer()
                Text("\(formattedWeekRange)")
                    .font(.headline)
                Spacer()
                Button(action: { moveWeek(by: 1) }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical, 5)

            // ✅ Weekdays Row
            HStack {
                ForEach(getWeekDays(), id: \.self) { day in
                    VStack {
                        Text(day, format: .dateTime.weekday(.short)) // "Mon", "Tue", etc.
                            .foregroundColor(.gray)
                        Text(day, format: .dateTime.day()) // Day number
                            .padding(8)
                            .background(isSelectedDay(day) ? Color.red : Color.clear)
                            .foregroundColor(isSelectedDay(day) ? .white : .black)
                            .clipShape(Circle())
                    }
                    .onTapGesture {
                        selectedDate = day
                    }
                }
            }
            .padding(.bottom, 10)

            // ✅ Shifts List
            ScrollView {
                VStack(spacing: 10) {
                    if filteredShifts.isEmpty {
                        Text("No shifts available for this day.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(filteredShifts) { shift in
                            ShiftCardView(shift: shift)
                        }
                    }
                }
                .padding()
            }

            // ✅ Weekly Hours Summary
            Text("Week summary \(formattedWeekRange) • \(totalWeeklyHours) hrs")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)
        }
        .onAppear {
            print("🔹 ScheduleView Appeared - Fetching Shifts")
            viewModel.fetchShifts()
        }
    }

    // ✅ Get Start & End Dates for the Current Week
    var formattedWeekRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let start = formatter.string(from: startOfWeek)
        let end = formatter.string(from: endOfWeek)
        return "\(start) - \(end)"
    }

    // ✅ Get Dates for the Current Week (Monday-Sunday)
    private func getWeekDays() -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Start week on Monday
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: selectedDate))!
        return (0...6).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    // ✅ Move Between Weeks
    private func moveWeek(by weeks: Int) {
        if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: selectedDate) {
            selectedDate = newDate
        }
    }

    // ✅ Check if Day is Selected
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
            .reduce(0) { $0 + $1.shiftId.totalHours }
    }

    private func isDateInCurrentWeek(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return Calendar.current.isDate(date, equalTo: selectedDate, toGranularity: .weekOfYear)
    }

}
