import Combine
import FirebaseFirestore
import Foundation

class GenerosViewModel: ObservableObject {

    @Published var generos: [Genero] = []
    @Published var cargando = false
    @Published var errorMensaje: String?

    private let service = GenerosService()

    func obtenerGeneros() async {
        cargando = true
        errorMensaje = nil

        do {
            let generos = try await service.obtenerGeneros()
            DispatchQueue.main.async {
                self.generos = generos
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMensaje = error.localizedDescription
            }
        }

        cargando = false
    }

    func obtenerGeneroDesdeRef(_ ref: DocumentReference) async throws -> Genero
    {
        return try await service.obtenerGenero(desde: ref)
    }

    func obtenerReferenciaGenero(genero: Genero) throws -> DocumentReference {
        return try service.obtenerGeneroRef(genero: genero)
    }
}
