import CoreData
import SwiftUI

struct AddTareasView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var tareasViewModel: TareasViewModel
    @State private var showAlert = false
    var meta: Metas
    init(context: NSManagedObjectContext, meta: Metas) {
        _tareasViewModel = StateObject(
            wrappedValue: TareasViewModel(context: context)
        )
        self.meta = meta
    }

    var body: some View {
        VStack {
            TextField("Título", text: $tareasViewModel.tarea)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Agregar") {
                tareasViewModel.guardarTarea(meta: meta)

                // Si hubo error, mostrar alerta
                if tareasViewModel.errorMessage != nil {
                    showAlert = true
                } else {
                    dismiss()  // cerrar si se guardó correctamente
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)

            Spacer()
        }
        .navigationTitle("Nueva Tarea")
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(
                    tareasViewModel.errorMessage
                        ?? "Ocurrió un error desconocido."
                ),
                dismissButton: .default(Text("OK")) {
                    tareasViewModel.errorMessage = nil
                }
            )
        }
    }
}
