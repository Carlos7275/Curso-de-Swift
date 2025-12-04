//
//  SwiftData_ImportExportApp.swift
//  SwiftData-ImportExport
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/12/25.
//

import SwiftData
import SwiftUI

@main
struct SwiftData_ImportExportApp: App {
    @State private var imcViewModel = IMCViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(imcViewModel)

        }.modelContainer(for: IMC.self)
    }
}
