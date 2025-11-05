//
//  TabViewMain.swift
//  NavegacionSwiftUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import SwiftUI

struct TabViewMain: View {
    var body: some View {
        TabView{
            ContentView().tabItem{
                Label("Home",systemImage: "house.fill")
            }
            TercerVista().tabItem{
                Label("Tercer Vista",systemImage: "plus")
            }
            CuartaVista().tabItem{
                Label("Cuarta Vista",systemImage: "camera")
            }
        }
    }
}
