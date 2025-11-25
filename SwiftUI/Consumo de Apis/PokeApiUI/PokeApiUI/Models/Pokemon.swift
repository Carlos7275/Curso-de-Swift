//
//  Pokemon.swift
//  PokeApiUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 05/11/25.
//
import Foundation

struct Pokemon: Decodable, Identifiable,Equatable {
    let name: String
    let url: String

    var id: Int {
        Int(url.split(separator: "/").last ?? "0") ?? 0
    }
    
    var imageURL: String {
          // obtiene el número del final de la url
          let id = url
              .components(separatedBy: "/")
              .filter { !$0.isEmpty }
              .last ?? "1"
          
          return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png"
      }
    
    static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
           lhs.id == rhs.id
       }
}
