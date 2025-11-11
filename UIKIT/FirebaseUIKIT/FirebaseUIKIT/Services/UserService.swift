import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import Foundation
import UIKit

class UserService {
    
    static let shared = UserService()
    func obtenerUsuario(uid: String) async throws -> Usuario {
        let snapshot = try await Firestore.firestore()
            .collection("usuarios")
            .document(uid)
            .getDocument()
        
        guard snapshot.exists else {
            throw NSError(
                domain: "Firestore",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Documento no encontrado"]
            )
        }
        
        let user = AuthService.shared.obtenerUsuario()!
        
        var usuario = try snapshot.data(as: Usuario.self)
        usuario.email = user.email
        return usuario
    }
    
    func actualizarUsuario(
        uid: String,
        cambios: [String: Any],
        foto: UIImage?,
        nuevoEmail: String? = nil
    ) async throws {
        
        let usuarioRef = Firestore.firestore()
            .collection("usuarios")
            .document(uid)
        
        var cambiosActualizados = cambios
        
        if let email = nuevoEmail, let currentUser = Auth.auth().currentUser {
            try await currentUser.sendEmailVerification(beforeUpdatingEmail: email)
        }
        
        if let foto = foto {
            guard let imageData = foto.jpegData(compressionQuality: 0.8) else {
                throw NSError(
                    domain: "StorageError",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "No se pudo convertir la imagen"]
                )
            }
            
            let fotoRef = Storage.storage()
                .reference()
                .child("usuarios/\(uid)/perfil.jpg")
            
            _ = try await fotoRef.putDataAsync(imageData)
            let url = try await fotoRef.downloadURL()
            cambiosActualizados["foto"] = url.absoluteString
        }
        
        try await usuarioRef.updateData(cambiosActualizados)
    }

}
