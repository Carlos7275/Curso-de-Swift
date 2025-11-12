import Combine
import MapKit
import SwiftUI

struct Home: View {

    @StateObject private var locationManager = LocationManager()

    // En lugar de region, ahora se usa la posición de cámara
    @State private var position: MapCameraPosition = .automatic
    @State private var subscripcion: AnyCancellable?

    func showLocation() {
        subscripcion = locationManager.$localizaciones.sink { localizacion in
            guard let localizacion else { return }

            position = .region(
                MKCoordinateRegion(
                    center: localizacion.coordinate,
                    latitudinalMeters: 1000,
                    longitudinalMeters: 1000
                )
            )
        }
    }

    var body: some View {
        Map(position: $position) {
            // Esto muestra el punto del usuario
            UserAnnotation()
        }
        .navigationTitle("Mapa SwiftUI")
        .onAppear {
            showLocation()
        }
    }
}

#Preview {
    Home()
}
