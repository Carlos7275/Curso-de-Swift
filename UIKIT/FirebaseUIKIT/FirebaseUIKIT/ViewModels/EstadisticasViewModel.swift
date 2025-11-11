//
//  EstadisticasViewModel.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 10/11/25.
//


import Foundation
import Combine

class EstadisticasViewModel: ObservableObject {
    
    private let service = EstadisticasService()
    private var subscriptions = Set<AnyCancellable>()
    
    // Estadísticas publicadas para que la UI se actualice automáticamente
    @Published var total: Int = 0
    @Published var favoritos: Int = 0
    @Published var noFavoritos: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Obtener estadísticas del mes actual
    func cargarEstadisticasMesActual() {
        isLoading = true
        errorMessage = nil
        
        service.obtenerEstadisticasMesActual { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let stats):
                    self?.total = stats.total
                    self?.favoritos = stats.favoritos
                    self?.noFavoritos = stats.noFavoritos
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
