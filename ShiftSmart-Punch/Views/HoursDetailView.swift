//import SwiftUI
//
//struct HoursDetailView: View {
//    let date: Date
//    let shifts: [Shift] // Now accepts multiple shifts
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var dateManager = DateRangeManager()
//    
//    private var totalHoursForDay: String {
//        let totalSeconds = shifts.reduce(0) { $0 + $1.duration }
//        let hours = Int(totalSeconds / 3600)
//        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
//        return String(format: "%d:%02d", hours, minutes)
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // Custom Navigation Bar
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
//                Text(dateManager.formatFullDate(date))
//                    .font(.title3)
//                    .fontWeight(.medium)
//                
//                Spacer()
//            }
//            .padding()
//            
//            // Today's shifts section
//            VStack(alignment: .leading, spacing: 16) {
//                Text("Today's shifts")
//                    .font(.title3)
//                    .fontWeight(.medium)
//                    .padding(.horizontal)
//                
//                ScrollView {
//                    VStack(spacing: 16) {
//                        ForEach(shifts) { shift in
//                            ShiftDetailCard(shift: shift)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//            .padding(.top)
//            
//            // Today's totals section
//            VStack(alignment: .leading, spacing: 16) {
//                Text("Today's totals")
//                    .font(.title3)
//                    .fontWeight(.medium)
//                    .padding(.horizontal)
//                    .padding(.top, 24)
//                
//                // Total hours card
//                VStack {
//                    Text("Total hours")
//                        .foregroundColor(.white)
//                        .font(.headline)
//                    Text(totalHoursForDay)
//                        .foregroundColor(.white)
//                        .font(.system(size: 48, weight: .medium))
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 24)
//                .background(Color.blue)
//                .cornerRadius(12)
//                .padding(.horizontal)
//            }
//            
//            Spacer()
//        }
//        .navigationBarHidden(true)
//        .background(Color.white.edgesIgnoringSafeArea(.all))
//    }
//}
//
//struct ShiftDetailCard: View {
//    let shift: Shift
//    
//    private var formattedClockIn: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "h:mm a"
//        return formatter.string(from: shift.startTime)
//    }
//    
//    private var formattedClockOut: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "h:mm a"
//        return formatter.string(from: shift.endTime)
//    }
//    
//    private var totalHours: String {
//        let hours = Int(shift.duration / 3600)
//        let minutes = Int((shift.duration.truncatingRemainder(dividingBy: 3600)) / 60)
//        return String(format: "%d:%02d", hours, minutes)
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            // Job used
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Job used")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                Text("Plainclothes Loss Prevention")
//                    .font(.body)
//                    .padding(8)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .background(Color.gray.opacity(0.2))
//                    .cornerRadius(8)
//            }
//            
//            // Location
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Location")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                Text(shift.location)
//                    .font(.body)
//            }
//            
//            // Times
//            HStack(spacing: 24) {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Clock In")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Text(formattedClockIn)
//                        .font(.body)
//                }
//                
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Clock Out")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Text(formattedClockOut)
//                        .font(.body)
//                }
//                
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Total")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Text(totalHours)
//                        .font(.body)
//                }
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .shadow(color: .gray.opacity(0.1), radius: 5)
//    }
//}
//
//#Preview {
//    NavigationView {
//        HoursDetailView(
//            date: Date(),
//            shifts: [Shift.preview()]
//        )
//    }
//} 
