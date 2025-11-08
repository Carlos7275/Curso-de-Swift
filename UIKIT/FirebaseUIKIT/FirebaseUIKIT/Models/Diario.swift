//
//  Diario.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//
import Foundation
import FirebaseFirestore

struct Diario: Codable {
    @DocumentID var id:String?
    let titulo: String
    let contenido: String
    let fecha: Date
    let favorito: Bool
    let emocion: String
}
