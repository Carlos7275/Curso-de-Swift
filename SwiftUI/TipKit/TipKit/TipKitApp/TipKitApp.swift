//
//  TipKitApp.swift
//  TipKit
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI
import TipKit

@main
struct TipKitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().task {
                try? Tips.configure(
                    [
                        .displayFrequency(.immediate),
                        .datastoreLocation(.applicationDefault),
                    ]

                )

            }
        }
    }
}
