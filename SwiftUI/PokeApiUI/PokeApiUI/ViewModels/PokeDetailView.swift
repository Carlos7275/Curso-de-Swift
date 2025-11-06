import SwiftUI
import Combine

@MainActor
final class PokeViewModel: ObservableObject {
    @Published var pokemones: [Pokemon] = []
    @Published var pokemonesFiltrados: [Pokemon] = []
    @Published var cargando = false
    @Published var mostrarError = false
    @Published var mensajeError: String = ""
    @Published var busqueda: String = ""
    @Published var noHayResultados = false

    private let service = PokeService()
    private var paginaActual = 1
    private let limite = 20
    private var cancellables = Set<AnyCancellable>()

    init() {
        $busqueda
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] texto in
                self?.filtrarPokemon(texto)
            }
            .store(in: &cancellables)
    }

    func resetearBusqueda() {
        paginaActual = 1
        pokemones = []
        pokemonesFiltrados = []
        noHayResultados = false
    }

    func cargarPokemones() async {
        guard !cargando else { return }
        cargando = true
        defer { cargando = false }
        
        try? await Task.sleep(nanoseconds: 300_000_000) // Delay opcional

        do {
            let response = try await service.obtenerListadoPokemones(pagina: paginaActual, limite: limite)
            
            if paginaActual == 1 {
                pokemones = response
            } else {
                pokemones.append(contentsOf: response)
            }
            
            paginaActual += 1
            filtrarPokemon(busqueda)
        } catch {
            mensajeError = error.localizedDescription
            mostrarError = true
        }
    }

    private func filtrarPokemon(_ texto: String) {
        if texto.isEmpty {
            pokemonesFiltrados = pokemones
        } else {
            pokemonesFiltrados = pokemones.filter { $0.name.lowercased().contains(texto.lowercased()) }
        }
        noHayResultados = pokemonesFiltrados.isEmpty
    }

    var shouldLoadMore: Bool {
        true // PokeAPI tiene muchos Pokémon, puedes usar un límite si quieres
    }
    
    
}
