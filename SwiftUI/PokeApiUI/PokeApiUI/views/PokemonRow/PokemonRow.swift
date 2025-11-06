//
//  PokemonRow.swift
//  PokeApiUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//
import SwiftUI

struct PokemonRow: View {
    let pokemon: Pokemon

    var body: some View {
        NavigationLink(destination: PokemonDetailView(nombreOId: pokemon.name)) {
            HStack {
                AsyncImage(url: URL(string: pokemon.imageURL)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(pokemon.name.capitalized)
                    .font(.headline)

                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}
