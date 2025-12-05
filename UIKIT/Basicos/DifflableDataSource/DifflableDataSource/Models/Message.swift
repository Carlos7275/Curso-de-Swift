//
//  Message.swift
//  DifflableDataSource
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/12/25.
//

import Foundation

struct Message: Hashable {
    let id: UUID
    let text: String
    let systemImageName: String

    init(id: UUID = UUID(), text: String, systemImageName: String) {
        self.id = id
        self.text = text
        self.systemImageName = systemImageName
    }
}

var items: [Message] = [
    Message(text: "Hola", systemImageName: "person"),
    Message(text: "¿Cómo estás?", systemImageName: "person.fill"),
    Message(text: "Bienvenido al chat", systemImageName: "star"),
    Message(text: "Recibiste un mensaje", systemImageName: "envelope"),
    Message(text: "Recordatorio: reunión a las 3", systemImageName: "bell"),
    Message(text: "Nuevo amigo agregado", systemImageName: "person.2"),
    Message(
        text: "Actualización disponible",
        systemImageName: "arrow.down.circle"
    ),
    Message(text: "Mensaje enviado", systemImageName: "paperplane"),
    Message(text: "Favorito guardado", systemImageName: "heart"),
    Message(
        text: "Alerta importante",
        systemImageName: "exclamationmark.triangle"
    ),
]
