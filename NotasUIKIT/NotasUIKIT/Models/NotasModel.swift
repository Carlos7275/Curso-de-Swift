import CoreData
//
//  NotasModel.swift
//  NotasUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 05/11/25.
//
import Foundation
import UIKit

class NotasModel: Modelo {
    //Singleton
    public static let shared = NotasModel()

    func guardarNota(titulo: String, descripcion: String, fecha: Date) {
        let contexto = obtenerContexto()
        let entidadNota =
            NSEntityDescription.insertNewObject(
                forEntityName: "Notas",
                into: contexto
            ) as! Notas

        entidadNota.titulo = titulo
        entidadNota.descripcion = descripcion
        entidadNota.fecha = fecha
        guardarContexto(contexto)

    }

    func eliminarNota(nota: Notas, contexto: NSManagedObjectContext) {
        contexto.delete(nota)
        guardarContexto(contexto)
    }

    func editarNota(
        titulo: String,
        descripcion: String,
        fecha: Date,
        nota: Notas
    ) {
        let contexto = obtenerContexto()

        nota.setValue(titulo, forKey: "titulo")
        nota.setValue(descripcion, forKey: "descripcion")
        nota.setValue(fecha, forKey: "fecha")

        guardarContexto(contexto)
    }

}
