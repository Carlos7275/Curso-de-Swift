//
//  MessagesViewModel.swift
//  ChatAPP
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import Combine
import FirebaseFirestore
import Foundation

class MessagesViewModel: ObservableObject {
    @Published var showChatApp: Bool = false
    @Published var messages: [Messages] = []
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    @Published var loading: Bool = false

    @Published var lastId: String? = nil

    let db = Firestore.firestore()

    init() {
        obtenerMensajes()
    }

    func obtenerMensajes() {
        loading = true
        db.collection("mensajes").addSnapshotListener { QuerySnapshot, error in
            guard let documentos = QuerySnapshot?.documents else { return }

            self.messages = documentos.compactMap({ (documento) -> Messages? in
                do {
                    return try documento.data(as: Messages.self)
                } catch {
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    return nil
                }
            })
            self.messages.sort { $0.timestamp < $1.timestamp }

            if let id = self.messages.last?.id {
                self.lastId = id
            }
        }
        loading = false
    }

    func enviarMensaje(mensaje: String) {
        do {
            guard let idUser = UserDefaults.standard.string(forKey: "idUser")
            else { return }
            guard
                let username = UserDefaults.standard.string(forKey: "username")
            else { return }

            let mensaje = Messages(
                id: "\(UUID())",
                text: mensaje,
                username: username,
                idUser: idUser,
                timestamp: Date()
            )
            try db.collection("mensajes").document().setData(from: mensaje)
        } catch let error as NSError {
            showError = true
            self.errorMessage = error.localizedDescription

        }
    }
}
