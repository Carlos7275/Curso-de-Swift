//
//  FotosViewModel.swift
//  CoreDataUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 12/11/25.
//

import Combine
import CoreData
import Foundation

class FotosViewModel: ObservableObject {
    @Published var errorMessage: String? = nil

    private let fotosRepository: CoreDataRepository<Fotos>

    init(context: NSManagedObjectContext) {
        self.fotosRepository = CoreDataRepository<Fotos>(
            modelName: "CoreDataUI"
        )
        self.fotosRepository.setContext(context)
    }

    func guardarFoto(_ foto: Data, _ tarea: Tareas) {
        do {
            let fotoNueva = try fotosRepository.create()
            fotoNueva.foto = foto
            fotoNueva.idTarea = tarea.id
            tarea.mutableSetValue(forKey: "relationToFotos").add(fotoNueva  )
            try fotosRepository.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func eliminarFoto(foto: Fotos) {
        do {
            try fotosRepository.delete(foto)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

}
