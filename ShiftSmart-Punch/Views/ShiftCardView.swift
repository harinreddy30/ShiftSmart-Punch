import SwiftUI

struct ShiftCardView: View {
    let shift: Shift
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                if let shiftDetails = shift.shiftId {
                    Text(shiftDetails.position)
                        .font(.headline)

                    Text("Site: \(shiftDetails.site.name)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Location: \(shiftDetails.site.location.address)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Start Time: \(shiftDetails.startTime) - End Time: \(shiftDetails.endTime)")
                        .foregroundColor(.gray)
                } else {
                    Text("Unassigned Shift")
                        .font(.headline)
                    
                    Text("Date: \(formatDate(shift.date))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("Day: \(shift.day)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Text("\(shift.totalHours) hrs")
                .padding(10)
                .background(Color.red.opacity(0.2))
                .cornerRadius(10)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        return displayFormatter.string(from: date)
    }
}
