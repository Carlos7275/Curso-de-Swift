import Combine
//
//  HomeViewModel.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 07/11/25.
//
import Foundation

class HomeViewModel: ObservableObject {
    @Published var usuarioSession = SesionUsuario.shared
    @Published var authService = AuthService.shared
    @Published var userService = UserService.shared

    func cargarUsuario() async throws {
        let id = authService.obtenerUID()!
        let usuario = try await userService.obtenerUsuario(uid: id)
        self.usuarioSession.usuario = usuario
    }
}
