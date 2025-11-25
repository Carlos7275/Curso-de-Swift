//
//  ActionsButtons.swift
//  DesignStacks
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//

import SwiftUI


struct ActionsButtons:View {
    var body : some View {
        HStack{
            Button(action:{PhoneService.sendCall(numero: "6682566496")}
            ){
                Image(systemName: "phone.fill").modifier(ButtonProperties(color: .blue))
                    
            }
        
            Button(action:
                    {PhoneService.sendMessage(numero: "6682566496", mensaje: "¡Hola que tal!")}){
                Image(systemName: "message.fill").modifier(ButtonProperties(color:.red))
            }
        }
        
    }
}
