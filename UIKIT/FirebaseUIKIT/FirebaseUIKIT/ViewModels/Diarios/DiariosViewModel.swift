//
//  DiariosViewModel.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 10/11/25.
//


import Foundation
import FirebaseFirestore

class DiariosViewModel: ObservableObject {
    @Published var diarios: [Diario] = []
    private var listener: ListenerRegistration?
    private let service = DiariosService()
    
    // Cargar diarios en tiempo real
    func cargarDiarios(busqueda: String? = nil, fecha: Date? = nil, favorito: Bool? = nil) {
        listener?.remove()
        listener = service.escucharDiarios(busqueda: busqueda, fecha: fecha, favorito: favorito) { [weak self] diarios in
            self?.diarios = diarios
        }
    }
    
    // Agregar diario con completion
    func agregar(_ diario: Diario, completion: ((Result<Void, Error>) -> Void)? = nil) {
        service.agregarDiario(diario) { result in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    // Modificar diario con completion
    func modificar(_ diario: Diario, completion: ((Result<Void, Error>) -> Void)? = nil) {
        service.modificarDiario(diario) { result in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    // Eliminar diario con completion
    func eliminar(_ diario: Diario, completion: ((Result<Void, Error>) -> Void)? = nil) {
        service.eliminarDiario(diario) { result in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    deinit {
        listener?.remove()
    }
}
