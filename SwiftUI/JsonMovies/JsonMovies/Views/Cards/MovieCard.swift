//
//  MovieCard.swift
//  JsonMovies
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 20/11/25.
//

import SwiftUI

struct MovieCard: View {
    let movie: Movies

    var body: some View {
        VStack(alignment: .leading) {

            // Imagen
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(height: 180)
            .clipped()
            .cornerRadius(12)

            // Texto
            Text(movie.title)
                .font(.headline)
                .lineLimit(2)

            Text(movie.releaseDate)
                .font(.subheadline)
                .foregroundStyle(.secondary)

        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(radius: 3)
    }
}
