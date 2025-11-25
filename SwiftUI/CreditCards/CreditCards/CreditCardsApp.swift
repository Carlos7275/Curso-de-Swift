//
//  CreditCardsApp.swift
//  CreditCards
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 21/11/25.
//

import CoreData
import SwiftUI

@main
struct CreditCardsApp: App {
    let persistence = CoreDataManager.shared(modelName: "CreditCards")

    var body: some Scene {
        WindowGroup {
            HomeView(context: persistence.context)

        }.environment(\.managedObjectContext, persistence.context)

    }
}
