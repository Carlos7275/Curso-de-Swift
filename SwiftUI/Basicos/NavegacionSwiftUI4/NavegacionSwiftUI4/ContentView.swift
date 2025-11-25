//
//  ContentView.swift
//  NavegacionSwiftUI4
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var root: ReturnRoot

    var body: some View {
        NavigationStack(path: $root.path) {
            VStack {
                NavigationLink("Segunda Vista", value: Rutas.Ruta2)
                NavigationLink("Tercera vista", value: Rutas.Ruta3)
                    .navigationDestination(for: Rutas.self) { ruta in
                        switch ruta {
                        case .Ruta2:
                            SegundaVista(item: "Valor que quiero")
                        case .Ruta3:
                            TerceraVista(item: "JIJIS")

                        }

                    }

            }.navigationTitle("Navigation Stack")
        }
    }
}

#Preview {
    ContentView()
}
