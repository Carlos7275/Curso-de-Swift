//
//  MKCoordinateRegion.swift
//  MapKitIOS17
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import MapKit

extension MKCoordinateRegion {
    static var userRegion: MKCoordinateRegion {
        return .init(
            center: .userLocation,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
    }
}
