//
//  ContentView.swift
//  ListasGrids
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import SwiftUI

struct ContentView: View {
   
    var body: some View {
        NavigationView{
            List(lista){ item in
                NavigationLink(destination:VistaDetalle(items:item)){
                    HStack{
                        emoji(emoji: item)
                        Text(item.nombre).font(.subheadline)

                    }
                }
            }.navigationTitle("Lista")
        }
    }
}

#Preview {
    ContentView()
}
