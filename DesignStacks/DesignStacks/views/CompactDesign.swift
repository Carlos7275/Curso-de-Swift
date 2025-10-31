//
//  CompactDesign.swift
//  DesignStacks
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//
import SwiftUI

struct CompactDesign:View {
    var color:Color
    var body: some View {
        ZStack{
            color.ignoresSafeArea()
            VStack(){
                Image("Image")
                    .resizable()
                    .frame(width: 130,height: 100,alignment: .center)
                    .clipShape(Circle())
                
                Text("Carlos Sandoval").font(.largeTitle).foregroundStyle(.white)
                    .bold()
                Text("FullStack Dev").foregroundColor(.white)
                    .font(.subheadline).italic()
                
                ActionsButtons()
                
            }
        }
    }
}
