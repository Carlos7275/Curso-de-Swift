//
//  RegularDesign.swift
//  DesignStacks
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//

import SwiftUI

struct RegularDesign:View {
    var color:Color
    var body: some View {
        ZStack{
            color.ignoresSafeArea()
            HStack(){
                Image("Image")
                    .resizable()
                    .frame(width: 130,height: 130,alignment: .center)
                    .clipShape(Circle())
                
                VStack(alignment: .leading,spacing: 10){
                    Text("Carlos Sandoval").font(.largeTitle).foregroundStyle(.white)
                        .bold()
                    Text("FullStack Dev").foregroundColor(.white)
                        .font(.subheadline).italic()
                 
                        ActionsButtons()
                }
            }
        }
    }
}
