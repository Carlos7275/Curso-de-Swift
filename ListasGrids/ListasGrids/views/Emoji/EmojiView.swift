//
//  EmojiView.swift
//  ListasGrids
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//
import SwiftUI

struct emoji:View{
    let emoji :Emoji
    var body: some View{
        ZStack{
            Text(emoji.emoji)
                .shadow(radius: 3)
                .font(.largeTitle)
                .frame(width: 48,height: 48)
                .overlay(Circle().stroke(Color.gray,lineWidth: 3))
            
        }
        
    }
}
