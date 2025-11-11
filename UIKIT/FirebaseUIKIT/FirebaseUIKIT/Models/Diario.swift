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
    var titulo: String
    var contenido: String
    var fechaCreacion: Date
    var favorito: Bool
}
