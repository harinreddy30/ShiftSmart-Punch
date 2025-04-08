import SwiftUI

struct LandingView: View {
    @Binding var showLanding: Bool
    let teamMembers = ["Shyam Patel", "Harin Reddy", "Meet Patel"]
    @State private var showContent = false
    @State private var showTeam = false
    
    var body: some View {
        ZStack {
            // Modern gradient background with animation
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "4158D0"),
                    Color(hex: "C850C0"),
                    Color(hex: "FFCC70")
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            .overlay(
                GeometryReader { geometry in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: geometry.size.width * 0.8)
                        .offset(x: -geometry.size.width * 0.2, y: -geometry.size.height * 0.2)
                        .blur(radius: 60)
                    
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: geometry.size.width * 0.6)
                        .offset(x: geometry.size.width * 0.5, y: geometry.size.height * 0.2)
                        .blur(radius: 60)
                }
            )
            
            VStack(spacing: 40) {
                // App Logo/Name with modern styling
                VStack(spacing: 20) {
                    Text("ShiftSmart")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 10)
                        .scaleEffect(showContent ? 1 : 0.5)
                        .opacity(showContent ? 1 : 0)
                    
                    Text("Manage Your Shifts Smartly")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.15))
                                .blur(radius: 5)
                        )
                        .offset(y: showContent ? 0 : 20)
                        .opacity(showContent ? 1 : 0)
                }
                .padding(.top, 60)
                
                Spacer()
                
                // Modern Team Members Display
                VStack(spacing: 25) {
                    Text("Development Team")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                        .opacity(showTeam ? 1 : 0)
                        .offset(y: showTeam ? 0 : 20)
                    
                    ForEach(Array(teamMembers.enumerated()), id: \.element) { index, member in
                        HStack(spacing: 15) {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(String(member.prefix(1)))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                )
                            
                            Text(member)
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white.opacity(0.15))
                                .blur(radius: 2)
                        )
                        .padding(.horizontal)
                        .opacity(showTeam ? 1 : 0)
                        .offset(x: showTeam ? 0 : -50)
                        .animation(.easeOut.delay(Double(index) * 0.1), value: showTeam)
                    }
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                showContent = true
            }
            
            withAnimation(.easeOut.delay(0.3)) {
                showTeam = true
            }
            
            // Auto-dismiss after 5 seconds with fade out animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    showContent = false
                    showTeam = false
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                showLanding = false
            }
        }
    }
}

// Helper extension for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 