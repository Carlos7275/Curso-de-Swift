import CoreData
import SwiftUI

struct AddMetaView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var metaModelView: MetasViewModel
    @State private var showAlert = false

    init(context: NSManagedObjectContext) {
        _metaModelView = StateObject(wrappedValue: MetasViewModel(context: context))
    }

    var body: some View {
        VStack {
            TextField("Título", text: $metaModelView.titulo)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Descripción", text: $metaModelView.descripcion)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Agregar") {
                metaModelView.guardarMetas()

                // Si hubo error, mostrar alerta
                if metaModelView.errorMessage != nil {
                    showAlert = true
                } else {
                    dismiss() // cerrar si se guardó correctamente
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top)

            Spacer()
        }
        .navigationTitle("Nueva Meta")
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(metaModelView.errorMessage ?? "Ocurrió un error desconocido."),
                dismissButton: .default(Text("OK")) {
                    metaModelView.errorMessage = nil
                }
            )
        }
    }
}
