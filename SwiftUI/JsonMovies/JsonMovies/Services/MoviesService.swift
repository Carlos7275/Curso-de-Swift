import Alamofire
import Foundation
import RxSwift

struct MoviesService {

    let secrets = PlistManager(fileName: "secrets")

    private var urlApi: String = ""
    private var apiKey: String = ""

    init(urlApi: String = "", apiKey: String = "") {
        self.urlApi = secrets["URL_API"]
        self.apiKey = secrets["API_KEY"]
    }

    func fetchAMovie(movie: String) -> Observable<Response<Movies>> {
        Observable.create { observer in
            let parameters: Parameters = [
                "api_key": apiKey,
                "query": movie,
                "language": "es-MX",
            ]

            let request = AF.request(
                "\(urlApi)/3/search/movie",
                parameters: parameters
            )
            .validate()
            .responseDecodable(
                of: Response<Movies>.self,
                queue: .global(qos: .userInitiated)
            ) { response in
                switch response.result {
                case .success(let moviesResponse):
                    observer.onNext(moviesResponse)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

    func fetchTrailer(movieID: Int) -> Observable<String?> {

        let parameters: Parameters = [
            "api_key": apiKey,
            "language": "es-MX",
        ]
        return Observable.create { observer in

            let request = AF.request(
                "\(urlApi)/3/movie/\(movieID)/videos",
                parameters: parameters
            )
            .validate()
            .responseDecodable(of: Response<MovieVideo>.self) {
                response in

                switch response.result {
                case .success(let videos):
                    // Filtrar el tráiler oficial de YouTube
                    let trailer = videos.results.first {
                        $0.site == "YouTube" && $0.type == "Trailer"
                    }

                    observer.onNext(trailer?.key)  // YouTube ID (o nil)
                    observer.onCompleted()

                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }

    }

    func fetchGeneralMovies(page: Int = 1) -> Observable<
        Response<Movies>
    > {
        let parameters: Parameters = [
            "api_key": apiKey,
            "language": "es-MX",
            "sort_by": "popularity.desc",
            "page": page,
        ]

        return Observable.create { observer in
            let request = AF.request(
                "\(urlApi)/3/discover/movie",
                parameters: parameters
            )
            .validate()
            .responseDecodable(
                of: Response<Movies>.self,
                queue: .global(qos: .userInitiated)
            ) { response in

                switch response.result {
                case .success(let moviesResponse):
                    observer.onNext(moviesResponse)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }

            return Disposables.create {
                request.cancel()
            }
        }
    }

}
