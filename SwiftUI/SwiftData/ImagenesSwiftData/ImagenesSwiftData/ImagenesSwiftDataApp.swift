//
//  ImagenesSwiftDataApp.swift
//  ImagenesSwiftData
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftData
import SwiftUI


@main
struct ImagenesSwiftDataApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().modelContainer(for: Photo.self)
        }
    }
}
