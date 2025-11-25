//
//  ContentView.swift
//  OnBoardView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 24/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CarrouselView()
                .tabItem {
                    Label("Carrousel", systemImage: "pencil")
                }
            ReelsView().frame(height: 1000).tabItem {
                Label("Reels", systemImage: "film")
            }

        }

    }
}

#Preview {
    ContentView()
}
