import Combine
//
//  Untitled.swift
//  ScrollView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//
import Foundation

class GenerosViewModel: ObservableObject {

    @Published var generos: [Generos] = []

    ///Simulación de cargar apis
    func cargarGeneros() async {
        generos = []
        //Simulamos una petición de una api
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 segundos
        generos.append(Generos(id: "1", nombre: "Masculino"))
        generos.append(Generos(id: "2", nombre: "Femenino"))
        generos.append(Generos(id: "3", nombre: "Indefinido"))

    }
}
