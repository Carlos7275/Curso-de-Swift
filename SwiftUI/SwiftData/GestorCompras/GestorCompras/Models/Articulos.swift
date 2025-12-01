//
//  Articulos.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 01/12/25.
//

import Foundation
import SwiftData

@Model
final class Articulos {

    @Attribute(.unique) var articulo: String
    var precio: Double
    var idCompra: String

    @Relationship(inverse: \Compras.relationArticulos)
    var listaRelacion: Compras?

    init(articulo: String = "", precio: Double = 0.0, idCompra: String = "") {
        self.articulo = articulo
        self.precio = precio
        self.idCompra = idCompra
    }
}
