import CoreData

enum CoreDataError: Error, LocalizedError {
    case fetchFailed(String)
    case saveFailed(String)
    case deleteFailed(String)
    case createFailed(String)

    var errorDescription: String? {
        switch self {
        case .fetchFailed(let msg): return "Error al obtener datos: \(msg)"
        case .saveFailed(let msg): return "Error al guardar: \(msg)"
        case .deleteFailed(let msg): return "Error al eliminar: \(msg)"
        case .createFailed(let msg): return "Error al crear: \(msg)"
        }
    }
}

final class CoreDataRepository<T: NSManagedObject> {
    private let manager: CoreDataManager
    private var context: NSManagedObjectContext

    init(modelName: String = "CoreDataUI") {
        self.manager = CoreDataManager.shared(modelName: modelName)
        self.context = manager.context
    }

    /// Permite reemplazar el contexto con el que provee SwiftUI (`@Environment(\.managedObjectContext)`)
    func setContext(_ context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - Crear
    func create() throws -> T {
        guard
            let entity = NSEntityDescription.insertNewObject(
                forEntityName: String(describing: T.self),
                into: context
            ) as? T
        else {
            throw CoreDataError.createFailed(
                "No se pudo crear la entidad \(T.self)"
            )
        }
        return entity
    }

    // MARK: - Leer
    func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        limit: Int? = nil
    ) throws -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let limit = limit { request.fetchLimit = limit }

        do {
            return try context.fetch(request)
        } catch {
            throw CoreDataError.fetchFailed(error.localizedDescription)
        }
    }

    // MARK: - Eliminar
    func delete(_ object: T) throws {
        context.delete(object)
        try save()
    }

    // MARK: - Guardar cambios
    func save() throws {
        do {
            if context.hasChanges {
                try context.save()
                context.refreshAllObjects()

            }
        } catch {
            throw CoreDataError.saveFailed(error.localizedDescription)
        }
    }

}
