//
//  FormView.swift
//  TipKitApp
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI
import TipKit

struct FormView: View {
    var body: some View {
        VStack {
            Text("Formulario").popoverTip(TipsView2(), arrowEdge: .bottom)
            Button {
                TipsView3.showTip = true
            } label: {
                Text("Guardar")
            }
            TipView(TipsView3())
        }.padding()
            .onAppear {
                Task {
                    await TipsView2.entrada.donate()
                }
            }

    }
}
