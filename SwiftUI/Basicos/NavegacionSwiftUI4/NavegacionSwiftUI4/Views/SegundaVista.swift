//
//  SegundaVista.swift
//  NavegacionSwiftUI4
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import SwiftUI

struct SegundaVista: View {
    var item: String

    @EnvironmentObject var root: ReturnRoot

    var body: some View {
        VStack {
            Text("Primer vista dice \(item)")
            Button("Regresar al principio") {
                root.root()
            }
        }.navigationTitle("Segunda vista")
    }
}
