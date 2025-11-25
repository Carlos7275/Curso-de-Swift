import Combine
import Foundation
import RxSwift

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movies] = []
    @Published var searchResults: [Movies] = []
    @Published var youtubeURL: String?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var showError = false
    @Published var page: Int = 1
    @Published var isSearching: Bool = false

    var currentMovies: [Movies] {
        return isSearching ? searchResults : movies
    }

    let disposeBag = DisposeBag()
    let moviesService: MoviesServiceProtocol

    
    init(service: MoviesServiceProtocol = MoviesService()) {
        moviesService = service
    }

    func fetch(movie: String) -> Observable<Response<Movies>> {
        return moviesService.fetchAMovie(movie: movie)
    }

    func fetchTrailer(movieID: Int) -> Observable<String?> {
        return moviesService.fetchTrailer(movieID: movieID)
    }

    func fetchAllMovies(page: Int) -> Observable<Response<Movies>> {
        return moviesService.fetchGeneralMovies(page: page)
    }

    // MARK: - Cargar películas generales
    func loadMovies() {
        isLoading = true
        isSearching = false

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

    // MARK: - Infinite scroll
    func loadMore(_ movie: Movies) {
        // No paginamos si estamos en búsqueda
        guard !isSearching else { return }
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

    // MARK: - Buscar películas
    func loadSearchMovies(movie: String) {
        isSearching = true
        self.isLoading = true
        fetch(movie: movie)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { element in
                    self.searchResults = element.results
                    self.isLoading = false

                },
                onError: { error in
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            )
            .disposed(by: disposeBag)
    }
}
