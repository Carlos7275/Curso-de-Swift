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
    
    var onMessagesUpdated: (() -> Void)?

    static let shared = MessagesViewModel()

    @Published var lastId: String? = nil

    let db = Firestore.firestore()

    init() {
        
        obtenerMensajes()
    }

    func obtenerMensajes() {
           loading = true
           db.collection("mensajes").addSnapshotListener { QuerySnapshot, error in
               guard let documentos = QuerySnapshot?.documents else { return }
               
               if let error = error {
                      self.showError = true
                      self.errorMessage = "No se pudo obtener mensajes: \(error.localizedDescription)"
                      return
                  }

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

               self.onMessagesUpdated?()
           }
           loading = false
       }

    func enviarMensaje(mensaje: String) {
        guard let idUser = UserDefaults.standard.string(forKey: "idUser") else { return }
        guard let username = UserDefaults.standard.string(forKey: "username") else { return }

        let mensaje = Messages(
            id: "\(UUID())",
            text: mensaje,
            username: username,
            idUser: idUser,
            timestamp: Date()
        )

        do {
            let docRef = db.collection("mensajes").document()
            try docRef.setData(from: mensaje) { [weak self] error in
                if let error = error {
                    self!.showError = true
                    self!.errorMessage = "No se pudo enviar el mensaje: \(error.localizedDescription)"
                }
            }
        } catch let error as NSError {
            // Error de serialización local
            showError = true
            errorMessage = "Error interno: \(error.localizedDescription)"
        }
    }

}
