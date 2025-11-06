import Foundation

final class PokeService {
    private let baseURL = "https://pokeapi.co/api/v2"
    /// Obtiene el listado de los pokemones 
    func obtenerListadoPokemones(pagina: Int = 1, limite: Int = 20) async throws -> [Pokemon] {
        let offset = (pagina - 1) * limite
        guard let url = URL(string: "\(baseURL)/pokemon?offset=\(offset)&limit=\(limite)") else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let decoded = try JSONDecoder().decode(PokemonResponse.self, from: data)
        return decoded.results
    }
    
    /// Obtiene los detalles de un Pokémon por id o nombre
        func obtenerDetallePokemon(idOName: String) async throws -> PokemonDetail {
            guard let url = URL(string: "\(baseURL)/pokemon/\(idOName.lowercased())") else {
                throw URLError(.badURL)
            }

            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                throw URLError(.badServerResponse)
            }

            return try JSONDecoder().decode(PokemonDetail.self, from: data)
        }
}
