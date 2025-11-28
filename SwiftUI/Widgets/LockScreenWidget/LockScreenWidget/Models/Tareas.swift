//
//  Tareas.swift
//  LockScreenWidget
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 27/11/25.
//

import Foundation

struct Tareas : Identifiable, Hashable {
    var id = UUID()
    var name : String
    var active : Bool
}

var tareas : [Tareas] = [

    Tareas(name: "Sacar la basura", active: false),
    Tareas(name: "Limpiar la oficina", active: true),
    Tareas(name: "Hacer la tarea", active: false)
    
]
