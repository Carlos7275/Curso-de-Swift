//
//  GestorComprasApp.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 28/11/25.
//

import Combine
import SwiftData
import SwiftUI

@main
struct GestorComprasApp: App {
    var body: some Scene {

        WindowGroup {
            ContentView()

                .modelContainer(for: Compras.self)

        }
    }
}
