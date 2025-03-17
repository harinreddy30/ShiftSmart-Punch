//import SwiftUI
//
//struct ActiveShiftView: View {
//    let shift: Shift
//    @State private var currentTime = Date()
//    @State private var shiftNote: String = ""
//    @State private var timer: Timer?
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var viewModel = ShiftsViewModel()
//    
//    private var formattedWorkTime: String {
//        // Start counting from when the view appears
//        let interval = currentTime.timeIntervalSince(Date())
//        let hours = Int(interval / 3600)
//        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
//        let seconds = Int(interval.truncatingRemainder(dividingBy: 60))
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
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
//                Text("GTA")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                
//                Spacer()
//                
//                HStack(spacing: 15) {
//                    Image(systemName: "calendar")
//                        .foregroundColor(.red)
//                    Image(systemName: "checkmark")
//                        .foregroundColor(.red)
//                }
//            }
//            .padding()
//            
//            // Active shift timer card
//            VStack(spacing: 20) {
//                Text("Work time on")
//                    .font(.title3)
//                    .foregroundColor(.white)
//                
//                Text(shift.location)
//                    .font(.headline)
//                    .foregroundColor(.blue)
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 8)
//                    .background(Capsule().fill(Color.white))
//                
//                Text(formattedWorkTime)
//                    .font(.system(size: 48, weight: .medium))
//                    .foregroundColor(.white)
//                    .monospacedDigit()
//                
//                HStack {
//                    Text("Total work hours today")
//                        .foregroundColor(.white.opacity(0.8))
//                    Spacer()
//                    Text(formattedWorkTime)
//                        .foregroundColor(.white)
//                }
//                .padding(.top, 20)
//            }
//            .padding(24)
//            .background(Color.blue)
//            
//            // Notes Section
//            VStack(alignment: .leading, spacing: 20) {
//                Text("Shift Notes")
//                    .font(.headline)
//                    .padding(.horizontal)
//                
//                TextEditor(text: $shiftNote)
//                    .frame(height: 100)
//                    .padding(8)
//                    .background(Color.gray.opacity(0.1))
//                    .cornerRadius(8)
//                    .padding(.horizontal)
//                
//                Button("Save Note") {
//                    // Save note logic here
//                }
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(10)
//                .padding(.horizontal)
//            }
//            .padding(.vertical)
//            
//            Spacer()
//            
//            // End Shift Button
//            Button(action: {
//                viewModel.clockOut(shiftId: shift.id)
//                dismiss()
//            }) {
//                Text("End Shift")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.red)
//                    .cornerRadius(10)
//            }
//            .padding()
//        }
//        .navigationBarHidden(true)
//        .onAppear {
//            startTimer()
//        }
//        .onDisappear {
//            stopTimer()
//        }
//    }
//    
//    private func startTimer() {
//        // Reset current time when starting timer
//        currentTime = Date()
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
