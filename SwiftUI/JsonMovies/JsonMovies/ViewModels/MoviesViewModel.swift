//
//  MoviesViewModel.swift
//  JsonMovies
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import Combine
import Foundation
import RxSwift

@MainActor
class MoviesViewModel: ObservableObject {
    @Published var movies: [Movies] = []
    @Published var youtubeURL: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError = false
    @Published var page: Int = 1

    let disposeBag = DisposeBag()

    let moviesService = MoviesService()

    func fetch(movie: String) -> Observable<Response<Movies>> {
        return moviesService.fetchAMovie(movie: movie)
    }

    func fetchTrailer(movieID: Int) -> Observable<String?> {
        return moviesService.fetchTrailer(movieID: movieID)
    }

    func fetchAllMovies(page: Int) -> Observable<Response<Movies>> {
        return moviesService.fetchGeneralMovies(page: page)
    }

    // MARK: - Llamar al ViewModel y hacer subscribe
    func loadMovies() {
        isLoading = true

        fetchAllMovies(page: page)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { response in
                    self.movies.append(contentsOf: response.results)
                    self.isLoading = false
                },
                onError: { error in
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                    self.isLoading = false
                }
            )
            .disposed(by: disposeBag)
    }

    // MARK: - Infinite Scroll automático
    func loadMore(_ movie: Movies) {
        guard !isLoading else { return }
        guard let index = movies.firstIndex(where: { $0.id == movie.id }) else {
            return
        }

        let threshold = movies.count - 4

        if index == threshold {
            page += 1
            loadMovies()
        }
    }

    func loadSearchMovies(movie: String) {
        fetch(movie: movie)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { element in
                    self.movies = element.results
                },
                onError: { error in
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            )
            .disposed(by: disposeBag)
    }

}
