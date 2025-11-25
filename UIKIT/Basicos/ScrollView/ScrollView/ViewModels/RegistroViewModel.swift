//
//  Untitled.swift
//  ScrollView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import Combine
import Foundation

class RegistroViewModel: ObservableObject {

    func registrarUsuario(usuario: UsuariosRequest, completion: @escaping (Bool) -> Void) {
        print("Usuario Registrado \(usuario)")

        // Simula que la API tarda 1.5 segundos
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            completion(true)
        }
    }

}
