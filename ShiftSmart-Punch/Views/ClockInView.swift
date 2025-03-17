//import SwiftUI
//
//struct ClockInView: View {
//    let shift: Shift
//    @State private var currentTime = Date()
//    @State private var totalHoursToday: String = "0:00"
//    @State private var shiftNote: String = ""
//    @State private var showNoteInput = false
//    @State private var timer: Timer?
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var viewModel = ShiftsViewModel()
//    @State private var isShowingActiveShift = false
//    @State private var isClockButtonBlue = false
//    
//    private var isClockInTime: Bool {
//        shift.clockInTime == nil
//    }
//    
//    private var formattedWorkTime: String {
//        guard let clockIn = shift.clockInTime else { return "0:00" }
//        let interval = currentTime.timeIntervalSince(clockIn)
//        let hours = Int(interval / 3600)
//        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
//        return String(format: "%d:%02d", hours, minutes)
//    }
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            // Top bar with back button and total hours
//            HStack {
//                Button(action: {
//                    dismiss()
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.red)
//                        .imageScale(.large)
//                }
//                
//                Spacer()
//                
//                VStack {
//                    Text("Total work hours today")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                    Text(formattedWorkTime)
//                        .font(.headline)
//                }
//                
//                Spacer()
//                
//                // Add Live button when clocked in
//                if shift.clockInTime != nil && shift.clockOutTime == nil {
//                    Button(action: {
//                        isShowingActiveShift = true
//                    }) {
//                        Text("LIVE")
//                            .font(.system(size: 14, weight: .bold))
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 8)
//                            .background(Capsule().fill(Color.blue))
//                    }
//                }
//                
//                Color.clear
//                    .frame(width: 24)
//            }
//            .padding()
//            
//            // Shift details card
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Plainclothes Loss Prevention")
//                    .font(.headline)
//                Text(shift.location)
//                    .foregroundColor(.gray)
//                Text("\(shift.startTime.formatted(date: .omitted, time: .shortened)) - \(shift.endTime.formatted(date: .omitted, time: .shortened))")
//                    .foregroundColor(.gray)
//            }
//            .padding()
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(10)
//            .padding(.horizontal)
//            
//            Spacer()
//            
//            // Clock in button
//            Button(action: {
//                viewModel.clockIn(shiftId: shift.id)
//                withAnimation {
//                    isClockButtonBlue = true
//                }
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    isShowingActiveShift = true
//                }
//            }) {
//                VStack(spacing: 15) {
//                    Image(systemName: "timer")
//                        .font(.system(size: 50))
//                    Text("Start shift")
//                        .font(.title3)
//                }
//                .foregroundColor(isClockButtonBlue ? .blue : .gray)
//                .frame(width: 200, height: 200)
//                .background(
//                    Circle()
//                        .stroke(isClockButtonBlue ? Color.blue : Color.gray, lineWidth: 2)
//                )
//            }
//            .disabled(shift.clockOutTime != nil)
//            
//            // Bottom timesheet button
//            NavigationLink(destination: TimesheetView()) {
//                VStack {
//                    Image(systemName: "calendar")
//                        .font(.system(size: 24))
//                        .foregroundColor(.blue)
//                    Text("Timesheet")
//                        .font(.caption)
//                        .foregroundColor(.black)
//                }
//                .frame(width: 120)
//                .padding(.vertical, 8)
//                .background(Color.white)
//                .cornerRadius(10)
//                .shadow(color: .gray.opacity(0.2), radius: 3)
//            }
//            .padding(.top, 30)
//        }
//        .navigationBarHidden(true)
//        .sheet(isPresented: $showNoteInput) {
//            ShiftNoteView(note: $shiftNote) {
//                viewModel.clockOut(shiftId: shift.id)
//                showNoteInput = false
//            }
//        }
//        .fullScreenCover(isPresented: $isShowingActiveShift) {
//            ActiveShiftView(shift: shift)
//        }
//        .onAppear {
//            if shift.clockInTime != nil && shift.clockOutTime == nil {
//                startTimer()
//            }
//            // Set initial button color based on clock in status
//            isClockButtonBlue = shift.clockInTime != nil
//        }
//        .onDisappear {
//            stopTimer()
//        }
//    }
//    
//    private func startTimer() {
//        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
//            currentTime = Date()
//        }
//    }
//    
//    private func stopTimer() {
//        timer?.invalidate()
//        timer = nil
//    }
//}
//
//struct ShiftNoteView: View {
//    @Binding var note: String
//    let onSubmit: () -> Void
//    @Environment(\.dismiss) private var dismiss
//    
//    var body: some View {
//        NavigationView {
//            VStack(spacing: 20) {
//                Text("Add a note about your shift")
//                    .font(.headline)
//                
//                TextEditor(text: $note)
//                    .frame(height: 150)
//                    .padding(8)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                
//                Button("Submit and Clock Out") {
//                    onSubmit()
//                    dismiss()
//                }
//                .foregroundColor(.white)
//                .padding()
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .cornerRadius(10)
//            }
//            .padding()
//            .navigationBarItems(
//                leading: Button("Cancel") {
//                    dismiss()
//                }
//            )
//        }
//    }
//}
//
//#Preview {
//    NavigationView {
//        ClockInView(shift: Shift.preview())
//    }
//} 
