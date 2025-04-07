import SwiftUI
import MapKit
import CoreLocation

struct ShiftMapView: View {
    let siteCoordinate: CLLocationCoordinate2D
    @Binding var userLocation: CLLocationCoordinate2D?
    @Binding var isWithinRange: Bool

    @State private var region = MKCoordinateRegion()

    var body: some View {
        Map(coordinateRegion: $region,
            annotationItems: pins) { pin in
            MapAnnotation(coordinate: pin.coordinate) {
                ZStack {
                    if pin.title == "Site" {
                        // ✅ FIXED: Circle anchored to site pin
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 100, height: 100) // 🔹 Reduced radius

                        Circle()
                            .stroke(Color.red, lineWidth: 2)
                            .frame(width: 100, height: 100)

                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)
                    } else {
                        Image(systemName: "location.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title)
                    }
                }
            }
        }
        .onAppear {
            region = MKCoordinateRegion(
                center: userLocation ?? siteCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
            checkProximity()
        }
        .onChange(of: userLocation?.latitude) { _ in
            checkProximity()
        }
    }

    private var pins: [MapPin] {
        var list = [MapPin(title: "Site", coordinate: siteCoordinate, color: .red)]
        if let user = userLocation {
            list.append(MapPin(title: "User", coordinate: user, color: .blue))
        }
        return list
    }

    private func checkProximity() {
        guard let user = userLocation else {
            isWithinRange = false
            return
        }

        let site = CLLocation(latitude: siteCoordinate.latitude, longitude: siteCoordinate.longitude)
        let userLoc = CLLocation(latitude: user.latitude, longitude: user.longitude)
        let distance = userLoc.distance(from: site)

        print("📍 Distance to site: \(Int(distance)) meters")
        isWithinRange = distance <= 50 // ✅ Optional: reduced real range too
    }

    struct MapPin: Identifiable {
        let id = UUID()
        let title: String
        let coordinate: CLLocationCoordinate2D
        let color: Color
    }
}
