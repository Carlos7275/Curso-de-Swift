//
//  OnBoardViee.swift
//  OnBoardView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 24/11/25.
//

import SwiftUI

struct OnBoardView: View {
    var image: String
    var title: String
    var desc: String

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.teal)

            Text(title).font(.title).bold()
            Text(desc).multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }.padding(.horizontal, 40)
    }
}


