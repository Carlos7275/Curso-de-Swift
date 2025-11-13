import SwiftUI

struct NavigationListComponent<T: Identifiable>: View {
    var title: String
    var items: [T]
    var rowContent: (T) -> AnyView
    var destination: (T) -> AnyView
    var toolbar: AnyView?
    var messageIfEmpty: String?
    var onDelete: ((T) -> Void)? = nil // recibe el objeto a eliminar

    @State private var mostrarAlerta = false
    @State private var itemAEliminar: T?

    var body: some View {
        Group {
            if items.isEmpty {
                VStack {
                    Spacer()
                    Text(messageIfEmpty ?? "Sin elementos")
                        .foregroundColor(.secondary)
                        .padding()
                    Spacer()
                }
            } else {
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: destination(item)) {
                            rowContent(item)
                        }
                    }
                    .onDelete { indexSet in
                        if let first = indexSet.first {
                            itemAEliminar = items[first]
                            mostrarAlerta = true
                        }
                    }
                }
            }
        }
        .navigationTitle(title)
        .toolbar {
            if let toolbar = toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    toolbar
                }
            }
        }
        // ALERTA DE CONFIRMACIÓN
        .alert(isPresented: $mostrarAlerta) {
            Alert(
                title: Text("¿Desea eliminar este elemento?"),
                message: Text("Esta acción no se puede deshacer"),
                primaryButton: .destructive(Text("Sí")) {
                    if let item = itemAEliminar {
                        onDelete?(item)
                    }
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
    }
}
