import CoreData
import Foundation

final class CoreDataManager {
    // Diccionario de instancias por modelo
    private static var instances: [String: CoreDataManager] = [:]

    // Singleton para cada modelo
    static func shared(modelName: String = "CoreDataUI") -> CoreDataManager {
        if let instance = instances[modelName] {
            return instance
        } else {
            let newInstance = CoreDataManager(modelName: modelName)
            instances[modelName] = newInstance
            return newInstance
        }
    }

    let container: NSPersistentContainer

    // Inicializador privado
    private init(modelName: String) {
        container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error cargando Core Data (\(modelName)): \(error)")
            }
        }
        // Configuración opcional: merge automático de cambios de otros contextos
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // Contexto principal
    var context: NSManagedObjectContext {
        container.viewContext
    }
}
