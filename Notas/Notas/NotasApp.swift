//
//  NotasApp.swift
//  Notas
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/11/25.
//

import SwiftUI
import CoreData

@main
struct NotasApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
