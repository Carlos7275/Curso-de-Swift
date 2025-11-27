//
//  ReportesAppApp.swift
//  ReportesApp
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 27/11/25.
//

import CoreData
import SwiftUI

@main
struct ReportesApp: App {
    let persistence = CoreDataManager.shared(modelName: "ReportesApp")

    var body: some Scene {
        WindowGroup {
            ContentView(viewContext: persistence.context)
                .environment(\.managedObjectContext, persistence.context)
        }
    }
}
