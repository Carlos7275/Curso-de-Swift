//
//  MapViewModel.swift
//  MapKitIOS17
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import Foundation
import MapKit
import Observation
import SwiftUI

@Observable
class MapViewModel {
    var cameraPosition: MapCameraPosition = .region(.userRegion)
    var search: String = ""
    var results = [MKMapItem]()

    var markerSelection: MKMapItem?
    var showLocation: Bool = false

    var getDirections: Bool = false
    var routeDisplay: Bool = false
    var route: MKRoute?
    var routeDestination: MKMapItem?

    func searchPlace() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = search
        request.region = .userRegion
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
        search = ""
        getDirections = false
        routeDisplay = false
    }

    func fetchRoute() {
        if let markerSelection {
            let request = MKDirections.Request()
            request.source = MKMapItem(
                placemark: .init(coordinate: .userLocation)
            )
            request.destination = markerSelection

            Task {
                let result = try? await MKDirections(request: request)
                    .calculate()
                route = result?.routes.first
                routeDestination = markerSelection
                withAnimation(.snappy) {
                    routeDisplay = true
                    showLocation = false
                    
                    if let rect = route?.polyline.boundingMapRect, routeDisplay{
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
    }
}
