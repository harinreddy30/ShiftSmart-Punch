import SwiftUI

struct ShiftCardView: View {
    let shift: Shift
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(shift.shiftId.position) // ✅ Shift role/title
                    .font(.headline)

                Text("Site: \(shift.shiftId.site.name)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Location: \(shift.shiftId.site.location.address)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text("Start Time: \(shift.shiftId.startTime) - End Time: \(shift.shiftId.endTime)")
                    .foregroundColor(.gray)
            }

            Spacer()

            // ✅ Move total hours inside the card for better alignment
            Text("\(shift.shiftId.totalHours) hrs")
                .padding(10)
                .background(Color.red.opacity(0.2))
                .cornerRadius(10)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
