import Combine
import CoreLocation
import CoreLocationUI
//
//  LocationManager.swift
//  Maps
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 11/11/25.
//
import Foundation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    let manager = CLLocationManager()

    @Published var localizaciones: CLLocation? = nil

    override init() {
        super.init()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocation locations: [CLLocation]
    ) {
        guard let localizacion = locations.first else { return }

        self.localizaciones = localizacion

    }

}
