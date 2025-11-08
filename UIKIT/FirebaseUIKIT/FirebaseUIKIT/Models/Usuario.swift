//
//  Usuario.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//

import Foundation
import FirebaseFirestore

struct Usuario:Decodable,Identifiable {
    @DocumentID var id:String?
    let nombres: String
    let apellidos: String
    let fechaNacimiento: String
    let foto: String
    
    enum CodingKeys: String, CodingKey {
            case id
            case nombres
            case apellidos
            case foto
            case fechaNacimiento = "fechanacimiento"  
        }
}
