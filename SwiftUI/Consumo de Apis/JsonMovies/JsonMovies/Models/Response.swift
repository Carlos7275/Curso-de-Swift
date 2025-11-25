import Foundation

// MARK: - Modelo genérico de respuesta
struct Response<T: Decodable>: Decodable {
    let id: Int?
    let page: Int?
    let results: [T]
    let totalPages: Int?
    let totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


