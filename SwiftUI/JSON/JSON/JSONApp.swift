//
//  JSONApp.swift
//  JSON
//
//  Created by Jorge Maldonado Borbón on 27/12/20.
//

import SwiftUI

@main
struct JSONApp: App {
    var body: some Scene {
        let login = PostViewModel()
        WindowGroup {
            ContentView().environmentObject(login)
        }
    }
}
