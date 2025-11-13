import CoreData
import SwiftUI

struct FotosView: View {
    @Environment(\.managedObjectContext) private var context

    @FetchRequest var fotos: FetchedResults<Fotos>
    var tarea: Tareas

    @StateObject var fotosViewModel: FotosViewModel

    // ImagePicker
    @State private var mostrarImagePicker = false
    @State private var imagenSeleccionada: Data = Data()
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var mostrarOpcionesFoto = false

    // Alerta de eliminación
    @State private var mostrarAlertaEliminar = false
    @State private var fotoAEliminar: Fotos?

    // Vista previa de la foto
    @State private var fotoSeleccionadaParaPreview: Fotos? = nil

    // MARK: - Init
    init(tarea: Tareas, context: NSManagedObjectContext) {
        self.tarea = tarea
        _fotos = FetchRequest(
            fetchRequest: FotosView.crearFetchRequest(tarea: tarea),
            animation: .default
        )
        _fotosViewModel = StateObject(
            wrappedValue: FotosViewModel(context: context)
        )
    }

    // MARK: - FetchRequest Helper
    static func crearFetchRequest(tarea: Tareas) -> NSFetchRequest<Fotos> {
        let request: NSFetchRequest<Fotos> = Fotos.fetchRequest()
        request.sortDescriptors = []
        if let idTarea = tarea.id {
            request.predicate = NSPredicate(format: "idTarea == %@", idTarea)
        }
        return request
    }

    // MARK: - Body
    var body: some View {
        VStack {
            if fotos.isEmpty {
                Spacer()
                Text("No hay fotos disponibles")
                    .foregroundColor(.secondary)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 100), spacing: 10)],
                        spacing: 10
                    ) {
                        ForEach(fotos, id: \.self) { foto in
                            if let data = foto.foto,
                               let uiImage = UIImage(data: data)
                            {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        fotoSeleccionadaParaPreview = foto
                                    }
                                    .overlay(
                                        // Botón de eliminar
                                        Button(action: {
                                            fotoAEliminar = foto
                                            mostrarAlertaEliminar = true
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                                .padding(4)
                                        }
                                        .background(Color.white.opacity(0.7))
                                        .clipShape(Circle())
                                        .padding(4),
                                        alignment: .topTrailing
                                    )
                            }
                        }
                    }
                    .padding()
                }
            }

            Button(action: {
                mostrarOpcionesFoto = true
            }) {
                Label("Agregar Foto", systemImage: "camera")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .actionSheet(isPresented: $mostrarOpcionesFoto) {
                ActionSheet(
                    title: Text("Selecciona una opción"),
                    buttons: [
                        .default(Text("Cámara")) {
                            sourceType = .camera
                            mostrarImagePicker = true
                        },
                        .default(Text("Galería")) {
                            sourceType = .photoLibrary
                            mostrarImagePicker = true
                        },
                        .cancel(),
                    ]
                )
            }
        }
        // ImagePicker Sheet
        .sheet(isPresented: $mostrarImagePicker) {
            ImagePicker(
                show: $mostrarImagePicker,
                image: $imagenSeleccionada,
                source: sourceType
            )
        }
        // Guardar foto al seleccionar
        .onChange(of: imagenSeleccionada) { nuevaData in
            guard !nuevaData.isEmpty else { return }
            fotosViewModel.guardarFoto(nuevaData, tarea)
        }
        // Alerta eliminar
        .alert(isPresented: $mostrarAlertaEliminar) {
            Alert(
                title: Text("¿Desea eliminar esta foto?"),
                message: Text("Esta acción no se puede deshacer"),
                primaryButton: .destructive(Text("Sí")) {
                    if let foto = fotoAEliminar {
                        fotosViewModel.eliminarFoto(foto: foto)
                    }
                },
                secondaryButton: .cancel(Text("No"))
            )
        }
        // Sheet para vista previa de foto
        .sheet(item: $fotoSeleccionadaParaPreview) { foto in
            if let data = foto.foto, let uiImage = UIImage(data: data) {
                ZStack {
                    Color.black.opacity(0.1) // Fondo semitransparente
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            fotoSeleccionadaParaPreview = nil // cerrar al tocar fondo
                        }

                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit) // mantiene proporciones
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.9,
                               maxHeight: UIScreen.main.bounds.height * 0.8)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding()
                }
            }
        }

        .navigationTitle("Fotos")
    }
}
