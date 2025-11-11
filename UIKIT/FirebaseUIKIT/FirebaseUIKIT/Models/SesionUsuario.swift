//
//  SesionUsuario.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 07/11/25.
//

class SesionUsuario {
    static let shared = SesionUsuario()
    private init() {}

    var usuario: Usuario?
}
