import SwiftUI

struct Home: View {
    @StateObject private var viewModel = PokeViewModel()

    var body: some View {
        NavigationStack {
            VStack {
            
                TextField("Buscar Pokémon", text: $viewModel.busqueda)
                    .padding(.vertical, 8)
                    .padding(.leading, 30)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            Spacer()
                        }
                    )
                    .padding(.horizontal)

                if viewModel.noHayResultados {
                    Spacer()
                    Text("No se encontraron Pokémon")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.pokemonesFiltrados) { pokemon in
                                PokemonRow(pokemon: pokemon)
                                    .onAppear {
                                        // Cargar más cuando llegamos al final
                                        if viewModel.shouldLoadMore && pokemon.id == viewModel.pokemonesFiltrados.last?.id {
                                            Task {
                                                await viewModel.cargarPokemones()
                                            }
                                        }
                                    }
                                Divider()
                            }

                            // Spinner al final de la lista
                            if viewModel.cargando {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Pokédex")
            .alert("Error", isPresented: $viewModel.mostrarError) {
                Button("Ok", role: .cancel) {}
            } message: {
                Text(viewModel.mensajeError)
            }
            .task {
                // Cargar los primeros Pokémon al inicio
                await viewModel.cargarPokemones()
            }
        }
    }
}

