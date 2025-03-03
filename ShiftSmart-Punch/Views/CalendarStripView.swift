import SwiftUI

struct CalendarStripView: View {
    @Binding var selectedDate: Date
    let calendar = Calendar.current
    
    private let daysToShow = 14 // Two weeks
    private let dayWidth: CGFloat = 40
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(getDates(), id: \.self) { date in
                    VStack {
                        Text(getDayName(date))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("\(calendar.component(.day, from: date))")
                            .font(.system(size: 20, weight: .medium))
                            .frame(width: dayWidth)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(isSelected(date) ? Color.blue : Color.clear)
                            )
                            .foregroundColor(isSelected(date) ? .white : .primary)
                    }
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding()
        }
    }
    
    private func getDates() -> [Date] {
        let today = calendar.startOfDay(for: Date())
        return (0..<daysToShow).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: today)
        }
    }
    
    private func getDayName(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, equalTo: selectedDate, toGranularity: .day)
    }
} 