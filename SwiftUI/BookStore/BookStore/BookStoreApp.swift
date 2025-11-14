//
//  BookStoreApp.swift
//  BookStore
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 12/11/25.
//

import SwiftUI

@main
struct BookStoreApp: App {

    @StateObject private var tienda = Tienda()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tienda)
        }
    }
}
