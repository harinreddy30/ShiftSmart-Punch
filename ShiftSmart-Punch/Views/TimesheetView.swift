//import SwiftUI
//
//struct TimesheetView: View {
//    @Environment(\.dismiss) private var dismiss
//    @ObservedObject private var dateManager = DateRangeManager()
//    @StateObject private var shiftsViewModel = ShiftsViewModel()
//    
//    // Sample shifts data
//    private let shiftsData: [Date: [Shift]] = {
//        let calendar = Calendar.current
//        let feb10 = calendar.date(from: DateComponents(year: 2024, month: 2, day: 10))!
//        let feb11 = calendar.date(from: DateComponents(year: 2024, month: 2, day: 11))!
//        let feb12 = calendar.date(from: DateComponents(year: 2024, month: 2, day: 12))!
//        let feb15 = calendar.date(from: DateComponents(year: 2024, month: 2, day: 15))!
//        
//        return [
//            feb10: [
//                Shift(
//                    id: "shift1",
//                    location: "8814 Big Carrot",
//                    date: feb10,
//                    startTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: feb10)!,
//                    endTime: calendar.date(bySettingHour: 19, minute: 15, second: 0, of: feb10)!,
//                    clockInTime: calendar.date(bySettingHour: 9, minute: 0, second: 0, of: feb10)!,
//                    clockOutTime: calendar.date(bySettingHour: 19, minute: 15, second: 0, of: feb10)!
//                )
//            ],
//            feb11: [
//                Shift(
//                    id: "shift2",
//                    location: "8814 Big Carrot",
//                    date: feb11,
//                    startTime: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: feb11)!,
//                    endTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: feb11)!,
//                    clockInTime: calendar.date(bySettingHour: 8, minute: 0, second: 0, of: feb11)!,
//                    clockOutTime: calendar.date(bySettingHour: 12, minute: 0, second: 0, of: feb11)!
//                ),
//                Shift(
//                    id: "shift3",
//                    location: "7911 No Frills - Damiano",
//                    date: feb11,
//                    startTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: feb11)!,
//                    endTime: calendar.date(bySettingHour: 20, minute: 15, second: 0, of: feb11)!,
//                    clockInTime: calendar.date(bySettingHour: 14, minute: 0, second: 0, of: feb11)!,
//                    clockOutTime: calendar.date(bySettingHour: 20, minute: 15, second: 0, of: feb11)!
//                )
//            ],
//            feb12: [
//                Shift(
//                    id: "shift4",
//                    location: "8814 Big Carrot",
//                    date: feb12,
//                    startTime: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: feb12)!,
//                    endTime: calendar.date(bySettingHour: 15, minute: 0, second: 0, of: feb12)!,
//                    clockInTime: calendar.date(bySettingHour: 11, minute: 0, second: 0, of: feb12)!,
//                    clockOutTime: calendar.date(bySettingHour: 15, minute: 0, second: 0, of: feb12)!
//                )
//            ]
//        ]
//    }()
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Header
//            HStack {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.red)
//                }
//                
//                Spacer()
//                
//                Text("Timesheet")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                
//                Spacer()
//                
//                Button(action: {
//                    // More options
//                }) {
//                    Image(systemName: "ellipsis")
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding()
//            
//            // Date Range Selector
//            HStack(spacing: 20) {
//                Button(action: {
//                    withAnimation {
//                        dateManager.previousWeek()
//                    }
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.black)
//                }
//                
//                Text(dateManager.getDateRangeText())
//                    .foregroundColor(.black)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 8)
//                    .background(Capsule().fill(Color.gray.opacity(0.1)))
//                
//                Button(action: {
//                    withAnimation {
//                        dateManager.nextWeek()
//                    }
//                }) {
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.black)
//                }
//                
//                Button(action: {
//                    withAnimation {
//                        dateManager.moveToToday()
//                    }
//                }) {
//                    Text("Today")
//                        .foregroundColor(.black)
//                        .padding(.horizontal, 16)
//                        .padding(.vertical, 8)
//                        .background(Capsule().fill(Color.gray.opacity(0.1)))
//                }
//            }
//            .padding(.vertical)
//            
//            // Week Total
//            HStack {
//                Text("Week total \(getWeekTotal())")
//                    .foregroundColor(.gray)
//                Button(action: {
//                    // Show more details
//                }) {
//                    Text("More")
//                        .foregroundColor(.black)
//                }
//            }
//            .padding(.vertical, 8)
//            .padding(.horizontal)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color.gray.opacity(0.05))
//            
//            // Daily Entries
//            ScrollView {
//                VStack(spacing: 0) {
//                    ForEach(dateManager.getDatesInRange(), id: \.self) { date in
//                        NavigationLink(destination: HoursDetailView(
//                            date: date,
//                            shifts: shiftsData[date] ?? []
//                        )) {
//                            DailyEntryRow(
//                                date: date,
//                                dayOfWeek: formatDayOfWeek(date),
//                                total: getTimeForDate(date)
//                            )
//                        }
//                    }
//                }
//            }
//        }
//        .navigationBarHidden(true)
//    }
//    
//    private func formatDayOfWeek(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEE"
//        return formatter.string(from: date)
//    }
//    
//    private func getTimeForDate(_ date: Date) -> String {
//        if let shifts = shiftsData[date] {
//            let totalSeconds = shifts.reduce(0) { $0 + $1.duration }
//            let hours = Int(totalSeconds / 3600)
//            let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
//            return String(format: "%d:%02d", hours, minutes)
//        }
//        return "0:00"
//    }
//    
//    private func getWeekTotal() -> String {
//        let totalSeconds = shiftsData.values.flatMap { $0 }.reduce(0) { $0 + $1.duration }
//        let hours = Int(totalSeconds / 3600)
//        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
//        return String(format: "%d:%02d", hours, minutes)
//    }
//}
//
//struct DailyEntryRow: View {
//    let date: Date
//    let dayOfWeek: String
//    let total: String
//    
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("\(Calendar.current.component(.day, from: date))")
//                    .font(.title2)
//                    .fontWeight(.medium)
//                Text(dayOfWeek)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            .frame(width: 60, alignment: .leading)
//            
//            VStack(alignment: .leading) {
//                Text("Daily Total")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                Text(total)
//                    .font(.body)
//                    .foregroundColor(total == "--" ? .gray : .blue)
//            }
//            
//            Spacer()
//            
//            Image(systemName: "chevron.right")
//                .foregroundColor(.blue)
//        }
//        .padding()
//        .background(
//            RoundedRectangle(cornerRadius: 10)
//                .fill(Color.white)
//                .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
//        )
//        .padding(.horizontal)
//        .padding(.vertical, 4)
//    }
//}
//
//#Preview {
//    NavigationView {
//        TimesheetView()
//    }
//} 
