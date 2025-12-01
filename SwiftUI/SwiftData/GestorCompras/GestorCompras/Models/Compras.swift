//
//  Compras.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 28/11/25.
//

import Foundation
import SwiftData

@Model
final class Compras {
    @Attribute(.unique)
    var id: String
    var titulo: String
    var fecha: Date
    var completado: Bool
    var presupuesto: Double
    var total: Double

    @Relationship(deleteRule: .cascade)

    var relationArticulos: [Articulos]

    init(
        id: String = UUID().uuidString,
        titulo: String = "",
        fecha: Date = .now,
        completado: Bool = false,
        presupuesto: Double = 0,
        total: Double = 0,
        relationArticulos: [Articulos] = []
    ) {
        self.id = id
        self.titulo = titulo
        self.fecha = fecha
        self.completado = completado
        self.presupuesto = presupuesto
        self.total = total
        self.relationArticulos = relationArticulos
    }
}
