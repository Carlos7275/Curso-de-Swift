//
//  MoviesServiceProtocol.swift
//  JsonMovies
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 21/11/25.
//

import UIKit
import RxSwift

protocol MoviesServiceProtocol {
    func fetchGeneralMovies(page: Int) -> Observable<Response<Movies>>
    func fetchAMovie(movie: String) -> Observable<Response<Movies>>
    func fetchTrailer(movieID: Int) -> Observable<String?>
}

