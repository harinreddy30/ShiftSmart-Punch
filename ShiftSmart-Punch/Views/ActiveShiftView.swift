import SwiftUI

struct ActiveShiftView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var clockViewModel: ClockViewModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            if let currentClockRecord = clockViewModel.currentClockRecord {
                Text("Active Shift")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(clockViewModel.formatTime(clockViewModel.workTime))
                    .font(.system(size: 60, weight: .bold, design: .monospaced))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Shift Notes")
                        .font(.headline)
                    
                    TextEditor(text: $clockViewModel.shiftNote)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Button(action: {
                    clockViewModel.clockOut()
                }) {
                    Text("End Shift")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(clockViewModel.isClockingOut)
                
                if clockViewModel.isClockingOut {
                    ProgressView("Ending shift...")
                }
            } else {
                Text("No active shift")
                    .font(.title)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .onChange(of: clockViewModel.error) { error in
            if let error = error {
                alertMessage = error
                showAlert = true
            }
        }
        .onChange(of: clockViewModel.currentClockRecord) { record in
            if record == nil {
                dismiss()
            }
        }
        .onDisappear {
            if clockViewModel.currentClockRecord == nil {
                clockViewModel.stopTimer()
                clockViewModel.workTime = 0
            }
        }
    }
}
