//
//  NavegacionSwiftUI4App.swift
//  NavegacionSwiftUI4
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import SwiftUI

@main
struct NavegacionSwiftUI4App: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(ReturnRoot())
        }
    }
}
