import SwiftUI

struct CalendarStripView: View {
    @Binding var selectedDate: Date
    private let calendar = Calendar.current

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(getWeekDates(), id: \.self) { date in
                    VStack {
                        Text(formatDay(date))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(formatDate(date))
                            .font(.headline)
                            .foregroundColor(selectedDate == date ? .white : .black)
                            .padding()
                            .background(selectedDate == date ? Color.blue : Color.clear)
                            .cornerRadius(10)
                    }
                    .onTapGesture {
                        selectedDate = date  // ✅ Update selected date
                    }
                }
            }
            .padding()
        }
    }

    // ✅ Get all days of the current week (Mon-Sun)
    private func getWeekDates() -> [Date] {
        guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: selectedDate)?.start else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    // ✅ Format Date (e.g., "12")
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }

    // ✅ Format Day (e.g., "Mon")
    private func formatDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        return formatter.string(from: date)
    }
}
