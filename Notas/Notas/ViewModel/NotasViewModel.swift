import Combine
import CoreData
//
//  ViewModel.swift
//  Notas
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/11/25.
//
import Foundation
import SwiftUI

class NotaViewModel: ObservableObject {

    @Published var textoNota = ""
    @Published var fechaNota = Date()
    @Published var mostrarFormulario = false
    @Published var notaSeleccionada: Notas?
    @Published var mostrarAlerta = false
    @Published var mensajeError = ""

    private func guardarContexto(_ contexto: NSManagedObjectContext) {
        do {
            try contexto.save()
            limpiarCampos()
            mostrarFormulario = false
        } catch {
            mensajeError = "No se pudo guardar. Error: \(error.localizedDescription)"
            mostrarAlerta = true
            contexto.rollback()

        }
    }

    private func limpiarCampos() {
        textoNota = ""
        fechaNota = Date()
        notaSeleccionada = nil
    }


    func agregarNota(contexto: NSManagedObjectContext) {
        let nuevaNota = Notas(context: contexto)
        nuevaNota.nota = textoNota
        nuevaNota.fecha = fechaNota
        guardarContexto(contexto)
    }

    func eliminarNota(_ nota: Notas, contexto: NSManagedObjectContext) {
        contexto.delete(nota)
        guardarContexto(contexto)
    }

    func cargarNota(_ nota: Notas) {
        notaSeleccionada = nota
        textoNota = nota.nota ?? ""
        fechaNota = nota.fecha ?? Date()
        mostrarFormulario = true
    }

    func actualizarNota(contexto: NSManagedObjectContext) {
        guard let nota = notaSeleccionada else { return }
        nota.nota = textoNota
        nota.fecha = fechaNota
        guardarContexto(contexto)
    }
}

