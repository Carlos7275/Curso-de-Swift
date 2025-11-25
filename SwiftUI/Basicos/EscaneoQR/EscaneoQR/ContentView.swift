//
//  ContentView.swift
//  EscaneoQR
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScannerView().tabItem {
                Label("Escanear Texto", systemImage: "doc.text.viewfinder")
            }

            QRView().tabItem {
                Label("Codigo QR", systemImage: "qrcode.viewfinder")
            }
        }
    }
}
