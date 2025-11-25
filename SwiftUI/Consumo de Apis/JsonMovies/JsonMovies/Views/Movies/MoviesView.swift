import RxSwift
import SwiftUI

struct MoviesView: View {

    var movie: String

    @StateObject var moviesViewModel: MoviesViewModel = MoviesViewModel()

    var body: some View {
        Group {
            if moviesViewModel.movies.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "film.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)

                    Text("No se encontraron películas")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16),
                        ],
                        spacing: 16
                    ) {
                        ForEach(moviesViewModel.movies) { movie in
                            NavigationLink(
                                destination: MovieDetailView(movie: movie)
                            ) {
                                MovieCard(movie: movie)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            moviesViewModel.loadSearchMovies(movie: movie)
        }
        .navigationTitle("Busqueda de \(movie)")
        .alert("Error", isPresented: $moviesViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(moviesViewModel.errorMessage)
        }
    }
}
