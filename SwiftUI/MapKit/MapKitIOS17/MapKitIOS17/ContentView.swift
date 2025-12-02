//
//  ContentView.swift
//  MapKitIOS17
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @Environment(MapViewModel.self) var mapViewModel
    @State private var showSearch = true
    var body: some View {
        @Bindable var mapViewModel = mapViewModel

        Map(
            position: $mapViewModel.cameraPosition,
            selection: $mapViewModel.markerSelection
        ) {
            Marker(
                "Mi ubicación",
                systemImage: "house",
                coordinate: .userLocation
            ).tint(.blue)

            ForEach(mapViewModel.results, id: \.self) {
                item in
                let placemark = item.placemark

                if mapViewModel.routeDisplay {
                    if item == mapViewModel.routeDestination {
                        Marker(
                            placemark.title ?? "",
                            coordinate: placemark.coordinate
                        )
                    }
                } else {

                    Marker(
                        placemark.title ?? "",
                        coordinate: placemark.coordinate
                    )
                }

            }

            if let route = mapViewModel.route {
                MapPolyline(route.polyline).stroke(.blue, lineWidth: 6)
            }

        }.overlay(alignment: .topLeading) {
            VStack {
                Button {
                    mapViewModel.showLocation = false
                    showSearch = true
                } label: {
                    Image(systemName: "magnifyingglass.circle.fill").font(
                        .largeTitle
                    )
                }
            }.padding(.leading, 15)

        }
        .onChange(
            of: mapViewModel.getDirections,
            { oldValue, newValue in
                if newValue {
                    mapViewModel.fetchRoute()
                }
            }
        )
        .onChange(
            of: mapViewModel.markerSelection,
            { oldValue, newValue in
                mapViewModel.showLocation = newValue != nil
            }
        )
        .sheet(
            isPresented: $showSearch,
            content: {
                SheetSearch(showSearch: $showSearch)
                    .interactiveDismissDisabled()
                    .presentationDetents([.height(150)])
                    .presentationCornerRadius(
                        15
                    )
                    .presentationBackground(.ultraThinMaterial)
            }
        )
        .sheet(
            isPresented: $mapViewModel.showLocation,
            content: {
                LocationView(
                    markerSelection: $mapViewModel.markerSelection,
                    showLocation: $mapViewModel.showLocation,
                    getDirections: $mapViewModel.getDirections
                ).presentationDetents([.height(350)])
                    .presentationBackgroundInteraction(
                        .enabled(upThrough: .height(350))
                    )
                    .presentationCornerRadius(15)
                    .presentationBackground(.ultraThinMaterial)
            }
        )
        .mapControls {
            MapCompass()
            MapPitchToggle()
            MapUserLocationButton()
        }
    }
}

#Preview {
    ContentView()
        .environment(MapViewModel())
}
