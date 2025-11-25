import FirebaseAuth
import FirebaseFirestore

class DiariosService {

    private let db = Firestore.firestore()
    private var lastDocument: DocumentSnapshot? = nil
    private let pageSizeDefault: Int = 10

    private func userDiariosRef() throws -> CollectionReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado"]
            )
        }
        return db.collection("usuarios").document(uid).collection("diarios")
    }

    // MARK: - Agregar diario
    func agregarDiario(
        _ diario: Diario,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        do {
            let ref = try userDiariosRef()
            let _ = try ref.addDocument(from: diario) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    // MARK: - Modificar diario
    func modificarDiario(
        _ diario: Diario,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let id = diario.id else {
            completion(
                .failure(
                    NSError(
                        domain: "",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "ID no disponible"
                        ]
                    )
                )
            )
            return
        }
        do {
            let ref = try userDiariosRef()
            try ref.document(id).setData(from: diario) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    // MARK: - Eliminar diario
    func eliminarDiario(
        _ diario: Diario,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let id = diario.id else {
            completion(
                .failure(
                    NSError(
                        domain: "",
                        code: -1,
                        userInfo: [
                            NSLocalizedDescriptionKey: "ID no disponible"
                        ]
                    )
                )
            )
            return
        }
        do {
            let ref = try userDiariosRef()
            ref.document(id).delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch let error {
            completion(.failure(error))
        }
    }

    // MARK: - Obtener diarios paginados con filtros
    func obtenerDiarios(
        busqueda: String? = nil,
        fecha: Date? = nil,
        favorito: Bool? = nil,
        pageSize: Int? = nil,
        resetPagination: Bool = false,
        completion: @escaping (Result<[Diario], Error>) -> Void
    ) {

        do {
            let ref = try userDiariosRef()

            if resetPagination { lastDocument = nil }

            var query: Query = ref

            // Filtro Firestore solo por favorito si existe
            if let fav = favorito {
                query = query.whereField("favorito", isEqualTo: fav)
            }

            query = query.order(by: "fechaCreacion", descending: true)
                .limit(to: pageSize ?? pageSizeDefault)

            if let lastDoc = lastDocument {
                query = query.start(afterDocument: lastDoc)
            }

            query.getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let snapshot = snapshot, !snapshot.documents.isEmpty
                else {
                    completion(.success([]))
                    return
                }

                self?.lastDocument = snapshot.documents.last

                var diarios: [Diario] = snapshot.documents.compactMap {
                    try? $0.data(as: Diario.self)
                }

                // Filtrado en memoria por favorito (para seguridad)
                if let fav = favorito {
                    diarios = diarios.filter { $0.favorito == fav }
                }

                // Filtrado por búsqueda
                if let busqueda = busqueda, !busqueda.isEmpty {
                    diarios = diarios.filter {
                        $0.titulo.lowercased().contains(busqueda.lowercased())
                            || $0.contenido.lowercased().contains(
                                busqueda.lowercased()
                            )
                    }
                }

                // Filtrar por fecha (solo día, mes, año)
                if let fechaFiltro = fecha {
                    let calendar = Calendar.current
                    diarios = diarios.filter {
                        calendar.isDate(
                            $0.fechaCreacion,
                            inSameDayAs: fechaFiltro
                        )
                    }
                }

                completion(.success(diarios))
            }

        } catch let error {
            completion(.failure(error))
        }
    }

    // MARK: - Escuchar diarios en tiempo real con filtros
    func escucharDiarios(
        busqueda: String? = nil,
        fecha: Date? = nil,
        favorito: Bool? = nil,
        callback: @escaping ([Diario]) -> Void
    ) -> ListenerRegistration? {
        do {
            let ref = try userDiariosRef()

            var query: Query = ref

            if let fav = favorito {
                query = query.whereField("favorito", isEqualTo: fav)
            }

            query = query.order(by: "fechaCreacion", descending: true)

            return query.addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    callback([])
                    return
                }

                var diarios = documents.compactMap {
                    try? $0.data(as: Diario.self)
                }

                // Filtrado en memoria por favorito
                if let fav = favorito {
                    diarios = diarios.filter { $0.favorito == fav }
                }

                // Filtrado por búsqueda
                if let busqueda = busqueda, !busqueda.isEmpty {
                    diarios = diarios.filter {
                        $0.titulo.lowercased().contains(busqueda.lowercased())
                            || $0.contenido.lowercased().contains(
                                busqueda.lowercased()
                            )
                    }
                }

                // Filtrar por fecha
                if let fechaFiltro = fecha {
                    let calendar = Calendar.current
                    diarios = diarios.filter {
                        calendar.isDate(
                            $0.fechaCreacion,
                            inSameDayAs: fechaFiltro
                        )
                    }
                }

                callback(diarios)
            }
        } catch {
            callback([])
            return nil
        }
    }

}
