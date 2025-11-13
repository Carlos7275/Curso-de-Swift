import CoreData
import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) var context
    @FetchRequest(
        entity: Metas.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Metas.titulo, ascending: true)
        ]
    ) var metas: FetchedResults<Metas>
    
    @StateObject var metaViewModel: MetasViewModel
    @State private var searchText: String = ""
    
    init(context: NSManagedObjectContext) {
        _metaViewModel = StateObject(
            wrappedValue: MetasViewModel(context: context)
        )
    }
    
    // Filtrar metas según el texto ingresado
    var filteredMetas: [Metas] {
        if searchText.isEmpty {
            return Array(metas)
        } else {
            return metas.filter { $0.titulo?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Barra de búsqueda en el diseño
                TextField("Buscar meta...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                NavigationListComponent(
                    title: "Metas",
                    items: filteredMetas,
                    rowContent: { meta in
                        AnyView(
                            VStack(alignment: .leading, spacing: 4) {
                                Text(meta.titulo ?? "")
                                    .font(.headline)
                                Text(meta.descripcion ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        )
                    },
                    destination: { meta in
                        AnyView(
                            TareasView(meta: meta, context: context)
                        )
                    },
                    toolbar: AnyView(
                        NavigationLink(destination: AddMetaView(context: context)) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                        }
                    ),
                    messageIfEmpty: "No hay metas disponibles",
                    onDelete: { meta in
                        metaViewModel.eliminarMetas(meta: meta)
                    }
                )
            }
        }
    }
}
