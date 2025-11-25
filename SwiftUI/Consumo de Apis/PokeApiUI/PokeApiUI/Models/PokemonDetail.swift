import Foundation
import Combine

struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [TypeEntry]
    let abilities: [AbilityEntry]
    let sprites: Sprites

    struct TypeEntry: Codable {
        let slot: Int
        let type: TypePokemon
        struct TypePokemon: Codable {
            let name: String
            let url: String
        }
    }

    struct AbilityEntry: Codable {
        let is_hidden: Bool
        let slot: Int
        let ability: Ability
        struct Ability: Codable {
            let name: String
            let url: String
        }
    }

    struct Sprites: Codable {
        let front_default: String?
        let back_default: String?
        let front_shiny: String?
        let back_shiny: String?
        let other: OtherSprites?

        struct OtherSprites: Codable {
            let officialArtwork: OfficialArtwork?

            enum CodingKeys: String, CodingKey {
                case officialArtwork = "official-artwork"
            }

            struct OfficialArtwork: Codable {
                let front_default: String?
            }
        }

        enum CodingKeys: String, CodingKey {
            case front_default, back_default, front_shiny, back_shiny, other
        }
    }
}
