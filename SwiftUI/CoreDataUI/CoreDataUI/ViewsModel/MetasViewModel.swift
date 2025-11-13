import Combine
import CoreData
import Foundation

class MetasViewModel: ObservableObject {
    @Published var titulo = ""
    @Published var descripcion = ""
    @Published var errorMessage: String? = nil

    private let metasRepository: CoreDataRepository<Metas>

    init(context: NSManagedObjectContext) {
        self.metasRepository = CoreDataRepository<Metas>(modelName: "CoreDataUI")
        self.metasRepository.setContext(context) 
    }

    func guardarMetas() {
        do {
            let meta = try metasRepository.create()
            meta.id = UUID().uuidString
            meta.titulo = titulo
            meta.descripcion = descripcion
            try metasRepository.save()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

 

    func eliminarMetas(meta: Metas) {
        do {
            try metasRepository.delete(meta)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func actualizarMetas(meta: Metas) {
        do {
            meta.titulo = titulo
            meta.descripcion = descripcion
            try metasRepository.save()
          
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
