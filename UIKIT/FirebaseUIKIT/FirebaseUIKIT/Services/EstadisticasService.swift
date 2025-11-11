//
//  Estadisticas.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 10/11/25.
//


import Foundation
import FirebaseFirestore
import FirebaseAuth

struct Estadisticas {
    let total: Int
    let favoritos: Int
    let noFavoritos: Int
}

class EstadisticasService {
    
    private let db = Firestore.firestore()
    
    private func userDiariosRef() throws -> CollectionReference {
        guard let uid = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuario no autenticado"])
        }
        return db.collection("usuarios").document(uid).collection("diarios")
    }
    
    func obtenerEstadisticasMesActual(completion: @escaping (Result<Estadisticas, Error>) -> Void) {
        do {
            let ref = try userDiariosRef()
            
            // Fecha inicio y fin del mes actual
            let calendar = Calendar.current
            let ahora = Date()
            
            guard
                let inicioMes = calendar.date(from: calendar.dateComponents([.year, .month], from: ahora)),
                let finMes = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: inicioMes)
            else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error al calcular fechas"])))
                return
            }
            
            ref.whereField("fechaCreacion", isGreaterThanOrEqualTo: inicioMes)
                .whereField("fechaCreacion", isLessThanOrEqualTo: finMes)
                .getDocuments { snapshot, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        completion(.success(Estadisticas(total: 0, favoritos: 0, noFavoritos: 0)))
                        return
                    }
                    
                    var favoritos = 0
                    var noFavoritos = 0
                    
                    for doc in documents {
                        if let diario = try? doc.data(as: Diario.self) {
                            if diario.favorito {
                                favoritos += 1
                            } else {
                                noFavoritos += 1
                            }
                        }
                    }
                    
                    let total = favoritos + noFavoritos
                    let estadisticas = Estadisticas(total: total, favoritos: favoritos, noFavoritos: noFavoritos)
                    completion(.success(estadisticas))
                }
            
        } catch {
            completion(.failure(error))
        }
    }
}
