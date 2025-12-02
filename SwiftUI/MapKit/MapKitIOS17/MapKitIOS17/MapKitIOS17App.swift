//
//  MapKitIOS17App.swift
//  MapKitIOS17
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI

@main
struct MapKitIOS17App: App {
    @State private var mapViewModel = MapViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView().environment(mapViewModel)
        }
    }
}
