//
//  WikiSynthesizerApp.swift
//  WikiSynthesizer
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI
import WikipediaKit

@main
struct WikiSynthesizerApp: App {

    @State private var voiceViewModel = VoiceViewModel()
    init() {
        WikipediaNetworking.appAuthorEmailForAPI = "sandovallizarragacarlos@gmail.com"

    }
    var body: some Scene {
        WindowGroup {
            ContentView().environment(voiceViewModel)
        }
    }
}
