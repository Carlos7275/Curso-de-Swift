//
//  Genero}.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 08/11/25.
//
import FirebaseFirestore

struct Genero: Decodable, Identifiable {
    @DocumentID var id: String?
    let genero: String
    let descripcion: String
}
