import Combine
import CoreData
import SwiftUI

struct TareasView: View {
    @FetchRequest var tareas: FetchedResults<Tareas>
    var meta: Metas
    @StateObject var tareasViewModel: TareasViewModel

    // Búsqueda
    @State private var searchText: String = ""

    init(meta: Metas, context: NSManagedObjectContext) {
        let request: NSFetchRequest<Tareas> = Tareas.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Tareas.tarea, ascending: true)
        ]

        if let idMeta = meta.id {
            request.predicate = NSPredicate(format: "idMeta == %@", idMeta)
        }

        _tareas = FetchRequest(fetchRequest: request)

        self.meta = meta
        _tareasViewModel = StateObject(
            wrappedValue: TareasViewModel(context: context)
        )
    }

    @Environment(\.managedObjectContext) private var context

    var filteredTareas: [Tareas] {
        if searchText.isEmpty {
            return Array(tareas)
        } else {
            return tareas.filter { ($0.tarea?.localizedCaseInsensitiveContains(searchText) ?? false) }
        }
    }

    var body: some View {
        VStack {
            // Buscador
            TextField("Buscar tarea...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top, 8)

            NavigationListComponent(
                title: meta.titulo ?? "Tareas",
                items: filteredTareas,
                rowContent: { tarea in
                    AnyView(
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tarea.tarea ?? "")
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    )
                },
                destination: { tarea in
                    AnyView(
                        FotosView(tarea: tarea, context: context)
                    )
                },
                toolbar: AnyView(
                    NavigationLink(
                        destination: AddTareasView(context: context, meta: meta)
                    ) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                ),
                messageIfEmpty: "No hay tareas disponibles",
                onDelete: { tarea in
                    tareasViewModel.eliminarTarea(tarea: tarea)
                }
            )
        }
    }
}
