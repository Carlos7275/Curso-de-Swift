//
//  IMCViewModel.swift
//  SwiftData-ImportExport
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/12/25.
//
import Foundation
import Observation

@Observable
class IMCViewModel {
    var nombre = ""
    var altura = ""
    var peso = ""
    var resIMC = "Respuesta"

    func limpiarCampos() {
        nombre = ""
        altura = ""
        peso = ""
        resIMC = "Respuesta"
    }

    func calcularIMC() -> String {
        var respuesta = ""

        if let pesoDouble = Double(peso), let alturaDouble = Double(altura),
            alturaDouble > 0
        {
            let imc = pesoDouble / (alturaDouble * alturaDouble)
            respuesta = String(format: "%.2f", imc)

            if imc < 18.5 {
                respuesta += " - Bajo peso"
            } else if imc < 24.9 {
                respuesta += " - Peso saludable"
            } else if imc < 29.9 {
                respuesta += " - Sobrepeso"
            } else {
                respuesta += " -  Obsesidad"
            }

        } else {
            respuesta = "Ingresa valores correctos para la altura y peso"
        }

        return respuesta

    }
}
