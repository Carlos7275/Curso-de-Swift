import FirebaseFirestore

class GenerosService {

    private let db = Firestore.firestore()

    /// Obtener todos los géneros
    func obtenerGeneros() async throws -> [Genero] {
        let snapshot = try await db.collection("generos").getDocuments()

        return try snapshot.documents.map { doc in
            var genero = try doc.data(as: Genero.self)
            genero.id = doc.documentID
            return genero
        }
    }

    /// Obtener un género desde un DocumentReference
    func obtenerGenero(desde ref: DocumentReference) async throws -> Genero {
        let snapshot = try await ref.getDocument()

        guard snapshot.exists else {
            throw NSError(
                domain: "GenerosService",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Género no encontrado"]
            )
        }

        return try snapshot.data(as: Genero.self)
    }

    func obtenerGeneroRef(genero: Genero)  throws-> DocumentReference {

        return  Firestore.firestore()
            .collection("generos")
            .document(genero.id!)
    }
}
