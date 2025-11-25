//
//  CarrouselView.swift
//  OnBoardView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 24/11/25.
//

import SwiftUI

struct CarrouselView: View {
    var body: some View {
        TabView {
            OnBoardView(
                image: "scribble.variable",
                title: "Scribe",
                desc:
                    "lorem iptussdadasdsadasdasdasdasdasdasdasdasdasdasdasdasdsad"
            )
            OnBoardView(
                image: "paintpalette.fill",
                title: "Scribe",
                desc:
                    "lorem iptussdadasdsadasdasdasdasdasdasdasdasdasdasdasdasdsad"
            )
            OnBoardView(
                image: "dial.min.fill",
                title: "Scribe",
                desc:
                    "lorem iptussdadasdsadasdasdasdasdasdasdasdasdasdasdasdasdsad"
            )
        }.tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(
                .page(
                    backgroundDisplayMode: .always
                )
            )
    }
}

