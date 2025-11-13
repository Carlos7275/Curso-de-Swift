//
//  TareasViewModel.swift
//  CoreDataUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 12/11/25.
//

import Combine
import CoreData
import Foundation

class TareasViewModel: ObservableObject {
    @Published var tarea = ""
    @Published var errorMessage: String? = nil

    private let tareasRepository: CoreDataRepository<Tareas>

    init(context: NSManagedObjectContext) {
        self.tareasRepository = CoreDataRepository<Tareas>(
            modelName: "CoreDataUI"
        )
        self.tareasRepository.setContext(context)
    }

    func guardarTarea(meta: Metas) {
        do {
            let tareaObj = try tareasRepository.create()
            tareaObj.id = UUID().uuidString
            tareaObj.tarea = tarea
            tareaObj.idMeta = meta.id
            meta.mutableSetValue(forKey: "relationToTareas").add(tareaObj)
            
            try tareasRepository.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func eliminarTarea(tarea: Tareas) {
        do {
            try tareasRepository.delete(tarea)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func actualizarTarea(tarea: Tareas) {
        do {
            tarea.tarea = self.tarea
            try tareasRepository.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
