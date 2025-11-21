import Foundation
import RxSwift
@testable import JsonMovies

class MoviesServiceMock: MoviesServiceProtocol {

    // MARK: - Control de errores
    var shouldReturnErrorGeneral = false
    var shouldReturnErrorSearch = false
    var shouldReturnErrorTrailer = false

    // MARK: - Datos mock
    var generalMoviesToReturn: [Movies] = []
    var searchMoviesToReturn: [Movies] = []
    var trailerURLToReturn: String? = nil

    // MARK: - Fetch general movies
    func fetchGeneralMovies(page: Int) -> Observable<Response<Movies>> {
        if shouldReturnErrorGeneral {
            return Observable.error(NSError(domain: "MockError", code: -1))
        }

        let response = Response<Movies>(
            id: nil,
            page: 1,
            results: generalMoviesToReturn,
            totalPages: 1,
            totalResults: generalMoviesToReturn.count
        )

        return Observable.just(response)
    }

    // MARK: - Fetch search movies
    func fetchAMovie(movie: String) -> Observable<Response<Movies>> {
        if shouldReturnErrorSearch {
            return Observable.error(NSError(domain: "MockError", code: -2))
        }

        let response = Response<Movies>(
            id: nil,
            page: 1,
            results: searchMoviesToReturn,
            totalPages: 1,
            totalResults: searchMoviesToReturn.count
        )

        return Observable.just(response)
    }

    // MARK: - Fetch trailer
    func fetchTrailer(movieID: Int) -> Observable<String?> {
        if shouldReturnErrorTrailer {
            return Observable.error(NSError(domain: "MockError", code: -3))
        }

        return Observable.just(trailerURLToReturn)
    }
}
