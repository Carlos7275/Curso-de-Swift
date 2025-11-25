//
//  PokeResponse.swift
//  PokeApiUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 05/11/25.
//

struct PokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}


