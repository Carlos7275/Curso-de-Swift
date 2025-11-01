//
//  ContentView.swift
//  DesignStacks
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//

import SwiftUI

struct ContentView: View {
    
    //Valores de entorno o EnviromentValues
    //En las nuevas versiones de IOS se recomienda usar vertical y en las anteriores horizontalSizeClass
    @Environment(\.verticalSizeClass)  var sizeClass
    
    var body: some View {
        if sizeClass == .compact {
            CompactDesign(color: .blue)
          } else {
              RegularDesign(color:.blue)
          }
        
    }
}

#Preview {
    ContentView()
}
