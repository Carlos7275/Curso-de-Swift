import Foundation

class PlistManager {
    private var dict: [String: Any] = [:]

    init(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "plist"),
              let data = try? Data(contentsOf: url),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let dict = plist as? [String: Any] else {
            fatalError("No se pudo cargar \(fileName).plist")
        }
        self.dict = dict
    }

    subscript<T>(key: String) -> T {
        guard let value = dict[key] as? T else {
            fatalError("No se encontró la clave '\(key)' o no es del tipo esperado")
        }
        return value
    }

    func allValues() -> [String: Any] {
        return dict
    }
}
