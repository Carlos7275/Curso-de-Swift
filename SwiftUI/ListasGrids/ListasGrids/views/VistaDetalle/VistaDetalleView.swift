//
//  VistaDetalleView.swift
//  ListasGrids
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import SwiftUI

struct VistaDetalle:View{
    var items:Emoji
    var body: some View{
        VStack(alignment: .leading, spacing: 3, content: {
            HStack{
                emoji(emoji: items)
                Text(items.nombre).font(.largeTitle)
                Spacer()
            }
            Text(items.descripcion).padding(.top)
            Spacer()
        }).padding(.all)
            .navigationTitle("Emojis")
    }
}
