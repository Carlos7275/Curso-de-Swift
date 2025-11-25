import Foundation
import Combine

@MainActor
final class PokeViewModel: ObservableObject {
    // Ventana visible
    @Published var pokemones: [Pokemon] = []
    // Ventana filtrada según búsqueda
    @Published var pokemonesFiltrados: [Pokemon] = []
    @Published var cargando = false
    @Published var mostrarError = false
    @Published var mensajeError: String = ""
    @Published var busqueda: String = ""
    @Published var noHayResultados = false

    private let service = PokeService()
    private var paginaActual = 1
    private let limite = 20

    // --- Windowing ---
    private var allPokemones: [Pokemon] = []
    private let ventana = 20
    private var inicioVentana = 0
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observa cambios en la búsqueda con debounce
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
        inicioVentana = 0
        allPokemones = []
        pokemones = []
        pokemonesFiltrados = []
        noHayResultados = false
    }

    // Carga de Pokémon desde la API
    func cargarPokemones() async {
        guard !cargando else { return }
        cargando = true
        defer { cargando = false }

        do {
            let response = try await service.obtenerListadoPokemones(
                pagina: paginaActual,
                limite: limite
            )
            allPokemones.append(contentsOf: response)
            paginaActual += 1
            actualizarVentana()
        } catch {
            mensajeError = error.localizedDescription
            mostrarError = true
        }
    }

    // Actualiza la ventana visible según inicioVentana y ventana
    private func actualizarVentana() {
        let fin = min(inicioVentana + ventana, allPokemones.count)
        if inicioVentana < fin {
            pokemones = Array(allPokemones[inicioVentana..<fin])
        }
        filtrarPokemon(busqueda)
    }

    // Avanza a la siguiente ventana
    func siguienteVentana() {
        if inicioVentana + ventana < allPokemones.count {
            inicioVentana += ventana
            actualizarVentana()
        } else {
            // Si no hay suficiente en allPokemones, carga más
            Task { await cargarPokemones() }
        }
    }

    // Retrocede a la ventana anterior
    func ventanaAnterior() {
        if inicioVentana - ventana >= 0 {
            inicioVentana -= ventana
            actualizarVentana()
        }
    }

    // Filtra la ventana según la búsqueda
    private func filtrarPokemon(_ texto: String) {
        if texto.isEmpty {
            pokemonesFiltrados = pokemones
        } else {
            pokemonesFiltrados = pokemones.filter { $0.name.lowercased().contains(texto.lowercased()) }
        }
        noHayResultados = pokemonesFiltrados.isEmpty
    }

    // Indica si se debe cargar la siguiente ventana al llegar al final del scroll
    var shouldLoadMore: Bool {
        guard let last = pokemonesFiltrados.last else { return false }
        return last.id == pokemones.last?.id
    }
}
