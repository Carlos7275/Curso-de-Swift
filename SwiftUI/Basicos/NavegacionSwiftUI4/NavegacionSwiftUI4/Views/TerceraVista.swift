//
//  TerceraVista.swift
//  NavegacionSwiftUI4
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import SwiftUI

struct TerceraVista: View {
    var item: String

    @EnvironmentObject var root: ReturnRoot

    var body: some View {
        Text("La tercera vista, recibiendo como parametro: \(item)")
        Button("Regresar") {
            root.path.removeLast()
        }

        Button("Regresar al root") {
            root.root()
        }
        .navigationTitle("Tercera vista")
    }
}
