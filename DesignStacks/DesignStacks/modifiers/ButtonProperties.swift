//
//  ButtonProperties.swift
//  DesignStacks
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//
import SwiftUI

struct ButtonProperties:ViewModifier{
    var color:Color
    func body(content: Content) -> some View {
        content .padding()
            .background(color)
            .clipShape(Circle())
            .foregroundColor(.white)
            .font(.title)
        
    }
}
