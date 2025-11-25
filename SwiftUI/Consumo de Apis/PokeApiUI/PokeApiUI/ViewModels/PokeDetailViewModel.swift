//
//  PokeDetailViewModel.swift
//  PokeApiUI
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 05/11/25.
//
import SwiftUI
import Combine

@MainActor
final class PokemonDetailViewModel: ObservableObject {
    @Published var pokemonDetalle: PokemonDetail?
    @Published var cargando = false
    @Published var mostrarError = false
    @Published var mensajeError: String = ""
    
    private let service = PokeService()
    
    /// Cargar detalle de Pokémon por nombre o id
    func cargarDetalle(nombreOId: String) async {
        guard !cargando else { return }
        cargando = true
        defer { cargando = false }
        
        do {
            let detalle = try await service.obtenerDetallePokemon(idOName: nombreOId)
            self.pokemonDetalle = detalle
        } catch {
            self.mensajeError = error.localizedDescription
            self.mostrarError = true
        }
    }
}

