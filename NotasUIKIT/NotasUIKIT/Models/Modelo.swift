//
//  Model.swift
//  NotasUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 05/11/25.
//

import UIKit
import CoreData

class Modelo {

    func obtenerContexto() -> NSManagedObjectContext {
        let delegado = UIApplication.shared.delegate as! AppDelegate
        return delegado.persistentContainer.viewContext
    }

    func guardarContexto(_ contexto: NSManagedObjectContext) {
        do {
            try contexto.save()
        } catch let error as NSError {
            print("Error al guardar:" + error.localizedDescription)
        }
    }
}
