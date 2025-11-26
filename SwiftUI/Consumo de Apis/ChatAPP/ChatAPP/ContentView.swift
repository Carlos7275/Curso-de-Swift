//
//  ContentView.swift
//  ChatAPP
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var login: MessagesViewModel
    var body: some View {
        return Group {
            if login.showChatApp {
                ChatView()
            } else {
                UsernameView()
            }
        }.onAppear {
            if UserDefaults.standard.object(forKey: "username") != nil {
                login.showChatApp = true
            }
        }
    }
}
