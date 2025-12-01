
//
//  CardView.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 28/11/25.
//

import Foundation
import SwiftUI


struct CardView: View {
    var item:Compras
    var body: some View {
        HStack{
            Circle()
                .foregroundStyle(item.completado ? .green : .red)
                .frame(width: 10,height: 10)
            VStack(alignment: .leading){
                Text(item.titulo).bold()
                Text("\(item.fecha ,format: Date.FormatStyle(date: .numeric, time: .shortened))").font(.callout)
                    .foregroundStyle(.gray)
            }
        }
    }
}

