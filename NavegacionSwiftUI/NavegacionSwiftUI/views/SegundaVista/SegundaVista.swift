//
//  SegundaVista.swift
//  NavegacionSwiftUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import SwiftUI

struct SegundaVista:View{
    var body: some View{
        Text("Hola desde SegundaVista")
            .navigationTitle("Segunda vista")
        
        NavigationLink(destination: TercerVista()){
            Text("Tercer Vista")
        
        }
    }
}
