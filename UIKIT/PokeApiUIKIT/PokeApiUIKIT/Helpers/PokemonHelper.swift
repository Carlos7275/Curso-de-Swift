//
//  PokemonHelper.swift
//  PokeApiUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//
import UIKit

// MARK: - Helpers
func colorTipo(tipo: String) -> UIColor {
    switch tipo.lowercased() {
    case "fire": return .red.withAlphaComponent(0.7)
    case "water": return .blue.withAlphaComponent(0.7)
    case "grass": return .green.withAlphaComponent(0.7)
    case "electric": return .yellow.withAlphaComponent(0.7)
    case "psychic": return .purple.withAlphaComponent(0.7)
    default: return .gray.withAlphaComponent(0.7)
    }
}
