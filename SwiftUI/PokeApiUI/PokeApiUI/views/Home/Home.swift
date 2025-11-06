import SwiftUI

struct Home: View {
    @StateObject private var viewModel = PokeViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                // Barra de búsqueda fija
                TextField("Buscar Pokémon", text: $viewModel.busqueda)
                    .padding(.vertical, 8)
                    .padding(.leading, 30)  // deja espacio para el icono
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
                                        if let last = viewModel
                                            .pokemonesFiltrados.last,
                                            pokemon.id == last.id,
                                            viewModel.shouldLoadMore
                                        {
                                            Task {
                                                await viewModel.cargarPokemones()
                                            }
                                        }
                                    }
                                Divider()
                            }

                            // Spinner al final
                            if viewModel.cargando {
                                ProgressView()
                                    .padding()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }.listStyle(.insetGrouped)
                .padding(.bottom, 10)
                .navigationTitle("Pokédex")
                .alert("Error", isPresented: $viewModel.mostrarError) {
                    Button("Ok", role: .cancel) {}
                } message: {
                    Text(viewModel.mensajeError)
                }
                .task {
                    await viewModel.cargarPokemones()
                }
        }
    }
}

struct PokemonRow: View {
    let pokemon: Pokemon

    var body: some View {
        NavigationLink(destination: PokemonDetailView(nombreOId: pokemon.name))
        {
            HStack {
                AsyncImage(url: URL(string: pokemon.imageURL)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(pokemon.name.capitalized)
                    .font(.headline)

                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}
