//
//  MoviesIntegrationTests.swift
//  JsonMovies
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 21/11/25.
//

import XCTest
import RxSwift
import Combine
@testable import JsonMovies

final class MoviesIntegrationTests: XCTestCase {

    var viewModel: MoviesViewModel!
    var realService: MoviesService!
    var cancellables: Set<AnyCancellable>!

    
    ///Seteamos nuestros servicios y modelos
    @MainActor
    override func setUp() {
        realService = MoviesService()
        viewModel = MoviesViewModel(service: realService)
        cancellables = Set<AnyCancellable>()
    }

    ///Destruimos los servicios y modelos
    override func tearDown() {
        viewModel = nil
        realService = nil
        cancellables = nil
    }

    ///Prueba de integracion de cargar peliculas
    @MainActor
    func test_fetchGeneralMovies_integration() {
        let expectation = expectation(description: "Calls real API")

        viewModel.$isLoading
            .dropFirst()
            .filter { $0 == false }
            .sink { _ in
                XCTAssertTrue(self.viewModel.currentMovies.count > 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadMovies()

        wait(for: [expectation], timeout: 5.0)
    }
    
    
    ///Prueba de integracion exitosa al buscar pelicula especifica
    ///Pelicula que busca es volver al futuro la cual hay 3
    @MainActor
    func test_fetchSearchMoviesSuccess_integration() {
        let expectation = expectation(description: "Calls to API to Search a Specific movie")

        viewModel.$isLoading
            .dropFirst()
            .filter { $0 == false }
            .sink { _ in
                XCTAssertTrue(self.viewModel.currentMovies.count > 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadSearchMovies(movie: "Volver al futuro") 

        wait(for: [expectation], timeout: 5.0)
    }
    
    ///Test de integracion de buscar peliculas inexistentes.
    @MainActor
    func test_fetchSearchMoviesFailed_integration() {
        let expectation = expectation(description: "Calls to API to Search a unexpected movie")

        viewModel.$isLoading
            .dropFirst()
            .filter { $0 == false }
            .sink { _ in
                XCTAssertTrue(self.viewModel.currentMovies.count == 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadSearchMovies(movie: "SELECT * FROM PELICULAS")

        wait(for: [expectation], timeout: 5.0)
    }
}
