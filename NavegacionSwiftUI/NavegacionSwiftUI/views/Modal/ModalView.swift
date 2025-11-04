//
//  ModalView.swift
//  NavegacionSwiftUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import SwiftUI

struct ModalView: View {
    @Environment(\.presentationMode) var back;
    var texto:String
    var body: some View {
        ZStack{
            Color.orange.edgesIgnoringSafeArea(.all)

            VStack{
                Text(texto)
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                
                Button("Cerrar"){
                    back.wrappedValue.dismiss()
                }
            }
            
        }
    }
}


