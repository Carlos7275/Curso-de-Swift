//
//  ButtonIcon.swift
//  WikiSynthesizer
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI

struct ButtonIcon: View {
    var icon: String
    var action: () -> Void
    var body: some View {
        Button(
            action: {
                action()
            },
            label: {
                Image(systemName: icon)
                    .font(.title)
                    .frame(width: 50, height: 50)
                    .foregroundStyle(.white)
                    .background(.blue)
                    .clipShape(Circle())
                
            }
        )
    }
}
