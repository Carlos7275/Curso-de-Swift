//
//  MoviesTest.swift
//  JsonMoviesTests
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 21/11/25.
//

import RxSwift
import XCTest
import Combine

@testable import JsonMovies

final class MoviesViewModelTest: XCTestCase {
    var viewModel: MoviesViewModel!
    var mockService: MoviesServiceMock!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        mockService = MoviesServiceMock()
        disposeBag = DisposeBag()
        viewModel = MoviesViewModel(service: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        disposeBag = nil
        super.tearDown()
    }
    // MARK: - Ejemplo de prueba
    @MainActor func test_loadMovies_success() {

        mockService.generalMoviesToReturn = [
            Movies.mock(id: 1, title: "Batman", overview: "Dark Knight"),
            Movies.mock(id: 2, title: "Superman", overview: "Man of Steel"),
        ]

        viewModel.loadMovies()

        XCTAssertEqual(viewModel.currentMovies.count, 2)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.showError)
    }

    @MainActor func test_loadMovies_failure() {
        mockService.shouldReturnErrorGeneral = true

        viewModel.loadMovies()

        XCTAssertTrue(viewModel.showError)
        XCTAssertFalse(viewModel.isLoading)
    }

    /// Testeamos la busqueda de peliculas
    @MainActor
    func test_searchMovies_failed() {
        let expectation = XCTestExpectation(description: "Search failed")

        mockService.shouldReturnErrorSearch = true

        var cancellable: AnyCancellable?

        cancellable = viewModel.$showError
            .dropFirst() 
            .filter { $0 == true }
            .sink { _ in
               
                XCTAssertEqual(self.viewModel.currentMovies.count, 0)
                expectation.fulfill()
                cancellable?.cancel()
            }

        viewModel.loadSearchMovies(movie: "Man")

        wait(for: [expectation], timeout: 1.0)
    }

    
    @MainActor
    func test_searchMovies_success() {
        let expectation = XCTestExpectation(description: "Search movies loaded")

        mockService.searchMoviesToReturn = [
            Movies.mock(id: 1, title: "Batman", overview: "Dark Knight")
        ]

        // Observamos cuando isLoading se vuelva false (ya terminó de cargar)
        var cancellable: AnyCancellable?

        cancellable = viewModel.$isLoading
            .dropFirst() // ignorar el valor inicial
            .filter { $0 == false } // cuando ya terminó
            .sink { _ in
                XCTAssertEqual(self.viewModel.currentMovies.count, 1)
                XCTAssertFalse(self.viewModel.showError)
                expectation.fulfill()
                cancellable?.cancel()
            }

        viewModel.loadSearchMovies(movie: "Batman")

        wait(for: [expectation], timeout: 1.0)
    }
    
 

}
