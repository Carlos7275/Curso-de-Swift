//
//  CardCompleteView.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 01/12/25.
//

import Foundation
import SwiftUI

struct CardCompleteView: View {
    var item: Compras
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(.green)
                .frame(width: 10, height: 10)
            VStack(alignment: .leading) {
                Text(item.titulo).bold()
                Text(
                    "Resto: \(item.presupuesto) Total Compra: $\(item.total.formatted())"
                ).font(.callout)
                    .foregroundStyle(.gray)
            }
        }
    }
}
