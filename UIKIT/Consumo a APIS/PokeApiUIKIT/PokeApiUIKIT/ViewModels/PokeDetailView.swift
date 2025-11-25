
import Foundation
import Combine

@MainActor
final class PokeViewModel: ObservableObject {
    @Published var pokemonesFiltrados: [Pokemon] = []
    @Published var cargando = false
    @Published var mostrarError = false
    @Published var mensajeError: String = ""
    @Published var busqueda: String = ""
    @Published var noHayResultados = false

    private let service = PokeService()
    private var paginaActual = 1
    private let limite = 20

    private var allPokemones: [Pokemon] = [] // Todos los Pokémon cargados
    private let ventana = 50 // tamaño de la ventana
    private var inicioVentana = 0 // índice de inicio de la ventana
    private var cancellables = Set<AnyCancellable>()

    init() {
        $busqueda
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] texto in
                self?.aplicarFiltro(texto)
            }
            .store(in: &cancellables)
    }

    func resetear() {
        paginaActual = 1
        inicioVentana = 0
        allPokemones = []
        pokemonesFiltrados = []
        noHayResultados = false
    }

    func cargarPokemones() async {
        guard !cargando else { return }
        cargando = true
        defer { cargando = false }

        do {
            let nuevos = try await service.obtenerListadoPokemones(pagina: paginaActual, limite: limite)
            paginaActual += 1
            allPokemones.append(contentsOf: nuevos)
            actualizarVentana()
        } catch {
            mensajeError = error.localizedDescription
            mostrarError = true
        }
    }

    private func actualizarVentana() {
        let fin = min(inicioVentana + ventana, allPokemones.count)
        guard inicioVentana < fin else { return }
        let ventanaActual = Array(allPokemones[inicioVentana..<fin])
        aplicarFiltro(busqueda, base: ventanaActual)
    }

    private func aplicarFiltro(_ texto: String, base: [Pokemon]? = nil) {
        let fuente = base ?? Array(allPokemones[inicioVentana..<min(inicioVentana+ventana, allPokemones.count)])
        if texto.isEmpty {
            pokemonesFiltrados = fuente
        } else {
            pokemonesFiltrados = fuente.filter { $0.name.lowercased().contains(texto.lowercased()) }
        }
        noHayResultados = pokemonesFiltrados.isEmpty
    }

    /// Mueve la ventana según el índice visible en la tabla
    func ventanaSegunIndice(_ indiceEnTabla: Int) {
        let indiceGlobal = inicioVentana + indiceEnTabla
        var nuevoInicio = indiceGlobal - ventana/2
        nuevoInicio = max(0, nuevoInicio)
        nuevoInicio = min(nuevoInicio, max(0, allPokemones.count - ventana))

        if nuevoInicio != inicioVentana {
            inicioVentana = nuevoInicio
            actualizarVentana()
        }

        // Cargar más si estamos cerca del final
        if indiceGlobal >= allPokemones.count - 5 {
            Task { await cargarPokemones() }
        }
    }
}
