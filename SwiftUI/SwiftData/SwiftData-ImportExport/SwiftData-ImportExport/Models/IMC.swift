//
//  IMC.swift
//  SwiftData-ImportExport
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/12/25.
//

import Foundation
import SwiftData

@Model
final class IMC {
    @Attribute(.unique) var id: String
    var nombre: String
    var imc: String

    init(id: String = UUID().uuidString, nombre: String, imc: String) {
        self.id = id
        self.nombre = nombre
        self.imc = imc
    }
}
