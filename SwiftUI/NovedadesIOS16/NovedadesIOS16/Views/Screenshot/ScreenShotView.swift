//
//  ScreenShotView.swift
//  NovedadesIOS16
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import SwiftUI

struct ScreenShotView: View {
    var body: some View {
        VStack {
            Text("Transferencia").font(.largeTitle).bold()

            Text("$10,000.00")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .padding(70)
                .background(.green)
                .clipShape(Circle())

            Grid(
                alignment: .leading,
                horizontalSpacing: 40,
                verticalSpacing: 10
            ) {
                GridRow {
                    Text("Nombre:").bold()
                    Text("Dexius")
                }
                GridRow {
                    Text("Cuenta:").bold()
                    Text("12992138124123123123921912")
                }
                GridRow {
                    Text("Folio:").bold()
                    Text("F-19901231")
                }
            }.padding(.top, 10)
            Spacer()

        }.padding(.all)
    }
}
