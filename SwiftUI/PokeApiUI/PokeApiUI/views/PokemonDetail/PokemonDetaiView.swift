import SwiftUI

struct PokemonDetailView: View {
    let nombreOId: String
    @StateObject private var viewModel = PokemonDetailViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if viewModel.cargando {
                    ProgressView("Cargando...")
                        .scaleEffect(1.5)
                        .padding()
                } else if let detalle = viewModel.pokemonDetalle {
                    Text(detalle.name.capitalized)
                        .font(.largeTitle)
                        .bold()

                    HStack {
                        Text("Altura: \(detalle.height)")
                        Text("Peso: \(detalle.weight)")
                    }
                    .font(.headline)

                    // Sprites
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(spriteURLs(detalle), id: \.self) { urlString in
                                if let url = URL(string: urlString) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 100, height: 100)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Tipos
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tipos:")
                            .font(.headline)
                        HStack {
                            ForEach(detalle.types, id: \.slot) { tipo in
                                Text(tipo.type.name.capitalized)
                                    .padding(6)
                                    .background(Color.blue.opacity(0.3))
                                    .cornerRadius(8)
                            }
                        }
                    }

                    // Habilidades
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Habilidades:")
                            .font(.headline)
                        ForEach(detalle.abilities, id: \.slot) { ability in
                            Text(ability.ability.name.capitalized + (ability.is_hidden ? " (Oculta)" : ""))
                        }
                    }

                } else {
                    Text("No se pudo cargar el Pokémon")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle(nombreOId.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $viewModel.mostrarError) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(viewModel.mensajeError)
        }
        .task {
            await viewModel.cargarDetalle(nombreOId: nombreOId)
        }
    }

    // Extrae todos los URLs de sprites que existan
    private func spriteURLs(_ detalle: PokemonDetail) -> [String] {
        var urls: [String] = []
        if let front = detalle.sprites.front_default { urls.append(front) }
        if let back = detalle.sprites.back_default { urls.append(back) }
        if let shinyFront = detalle.sprites.front_shiny { urls.append(shinyFront) }
        if let shinyBack = detalle.sprites.back_shiny { urls.append(shinyBack) }
        if let official = detalle.sprites.other?.officialArtwork?.front_default { urls.append(official) }
        return urls
    }
}
