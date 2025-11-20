import RxSwift
import SwiftUI

struct HomeView: View {

    @State private var search = ""
    @State private var isSearch: Bool = false

   @StateObject private var viewModel = MoviesViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        NavigationStack {
            VStack {

                HStack {
                    TextField("Buscar....", text: $search)
                        .textFieldStyle(.roundedBorder)

                    Button {
                        isSearch.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .padding(8)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 15)
                .padding(.bottom, 20)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {

                        ForEach(Array(viewModel.movies.enumerated()), id: \.offset) { index, movie in
                            NavigationLink(
                                destination: MovieDetailView(movie: movie)
                            ) {
                                MovieCard(movie: movie)
                            }
                            .onAppear {
                                viewModel.loadMore(movie)
                            }
                            .buttonStyle(.plain)
                        }

                        if viewModel.isLoading {
                            ProgressView().padding()
                        }
                    }
                    .padding(.horizontal, 10)
                }

                .navigationDestination(isPresented: $isSearch) {
                    MoviesView(movie: search)
                }

            }
            .padding(.horizontal)
            .navigationTitle("Buscador de peliculas")
            .onAppear {
                viewModel.loadMovies()
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }

        }
    }

  
}
