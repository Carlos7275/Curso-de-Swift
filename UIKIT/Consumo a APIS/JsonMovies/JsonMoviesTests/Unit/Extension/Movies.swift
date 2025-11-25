//
//  Movies.swift
//  JsonMovies
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 21/11/25.
//

@testable import JsonMovies

extension Movies {
    static func mock(
        id: Int = 1,
        title: String = "Movie Test",
        overview: String = "Overview",
        adult: Bool = false,
        backdropPath: String? = nil,
        genreIDS: [Int] = [],
        originalLanguage: String = "en",
        originalTitle: String = "Movie Test",
        popularity: Double = 0,
        posterPath: String? = nil,
        releaseDate: String = "2025-01-01",
        video: Bool = false,
        voteAverage: Double = 5.0,
        voteCount: Int = 100
    ) -> Movies {
        return Movies(
            adult: adult,
            backdropPath: backdropPath,
            genreIDS: genreIDS,
            id: id,
            originalLanguage: originalLanguage,
            originalTitle: originalTitle,
            overview: overview,
            popularity: popularity,
            posterPath: posterPath,
            releaseDate: releaseDate,
            title: title,
            video: video,
            voteAverage: voteAverage,
            voteCount: voteCount
        )
    }
}
