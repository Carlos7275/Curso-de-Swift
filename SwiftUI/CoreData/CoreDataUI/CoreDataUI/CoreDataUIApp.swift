//
//  CoreDataUIApp.swift
//  CoreDataUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 12/11/25.
//

import SwiftUI
import CoreData

@main
struct CoreDataUIApp: App {
    let persistence = CoreDataManager.shared(modelName: "CoreDataUI")

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.context)
        }
    }
}
