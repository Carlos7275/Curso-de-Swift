import Foundation
import Combine
import FirebaseFirestore

class DiariosViewModel: ObservableObject {
    
    @Published var diarios: [Diario] = []
    
    private let service = DiariosService()
    private var listener: ListenerRegistration?
    private var isFetching = false
    
    // MARK: - Paginación
    private var hasMore = true
    private var pageSize: Int = 10
    private var busquedaActual: String?
    private var favoritoActual: Bool?
    
    
    
    // MARK: - Cargar primera página o reset
    func cargarDiarios(busqueda: String? = nil,
                       favorito: Bool? = nil,
                       pageSize: Int = 10) {
        
        self.busquedaActual = busqueda
        self.favoritoActual = favorito
        self.pageSize = pageSize
        self.hasMore = true
        self.diarios = []
        
        cargarSiguientePagina()
    }
    
     
    // MARK: - Cargar siguiente página
    func cargarSiguientePagina() {
        guard hasMore, !isFetching else { return }
        isFetching = true
        
        service.obtenerDiarios(busqueda: busquedaActual,
                               favorito: favoritoActual,
                               pageSize: pageSize,
                               resetPagination: diarios.isEmpty) { [weak self] result in
            guard let self = self else { return }
            self.isFetching = false
            
            switch result {
            case .success(let nuevosDiarios):
                if nuevosDiarios.count < self.pageSize {
                    self.hasMore = false
                }
                self.diarios.append(contentsOf: nuevosDiarios)
            case .failure(let error):
                print("Error al cargar diarios:", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Agregar diario
    func agregar(_ diario: Diario, completion: ((Result<Void, Error>) -> Void)? = nil) {
        service.agregarDiario(diario) { result in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    // MARK: - Modificar diario
    func modificar(_ diario: Diario, completion: ((Result<Void, Error>) -> Void)? = nil) {
        service.modificarDiario(diario) { result in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    // MARK: - Eliminar diario
    func eliminar(_ diario: Diario, completion: ((Result<Void, Error>) -> Void)? = nil) {
        service.eliminarDiario(diario) { result in
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    // MARK: - Escuchar diarios en tiempo real (opcional)
    func escucharDiarios(busqueda: String? = nil,
                         fecha: Date? = nil,
                         favorito: Bool? = nil) {
        listener?.remove()
        listener = service.escucharDiarios(busqueda: busqueda,
                                           fecha: fecha,
                                           favorito: favorito) { [weak self] diarios in
            self?.diarios = diarios
        }
    }
    
    deinit {
        listener?.remove()
    }
}
