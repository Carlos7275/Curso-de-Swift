import RxSwift
import SwiftUI

struct MovieDetailView: View {
    let movie: Movies
    @State private var images: [String] = []

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {

                if !images.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(images, id: \.self) { path in
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(path)")) { image in
                                    image.resizable().scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 320, height: 200)
                                .clipped()
                                .cornerRadius(12)
                            }
                        }
                        .padding(.horizontal)
                    }
                } else {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(movie.backdropPath ?? movie.posterPath ?? "")")) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(height: 220)
                    .clipped()
                }

                HStack(alignment: .top, spacing: 16) {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w342\(movie.posterPath ?? "")")) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 140, height: 200)
                    .cornerRadius(12)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(movie.title)
                            .font(.title2.bold())

                        if movie.originalTitle != movie.title {
                            Text(movie.originalTitle)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        Text("⭐️ \(String(format: "%.1f", movie.voteAverage)) / 10")
                            .font(.headline)

                        Text("Popularidad: \(Int(movie.popularity))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Votos: \(movie.voteCount)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                Text("📅 Fecha de estreno: \(movie.releaseDate)")
                    .font(.subheadline)
                    .padding(.horizontal)

                Divider().padding(.horizontal)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Descripción")
                        .font(.title3.bold())

                    if !movie.overview.isEmpty {
                        Text(movie.overview)
                            .font(.body)
                    } else {
                        Text("Sin descripción disponible.")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                Spacer().frame(height: 40)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadImages()
        }
    }

    private func loadImages() {
        self.images = [
            movie.backdropPath ?? "",
            movie.posterPath ?? ""
        ].filter { !$0.isEmpty }
    }
}
