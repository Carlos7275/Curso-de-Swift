//
//  Usuario.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//

import FirebaseFirestore
import Foundation

struct Usuario: Decodable, Identifiable {
    @DocumentID var id: String?
    var nombres: String
    var apellidos: String
    var fechaNacimiento: String
    var foto: String
    var email: String?
    var genero: DocumentReference

    enum CodingKeys: String, CodingKey {
        case id
        case nombres
        case apellidos
        case foto
        case genero
        case email
        case fechaNacimiento = "fechanacimiento"
    }
}
