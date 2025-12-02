//
//  AddPhoto.swift
//  ImagenesSwiftData
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import PhotosUI
import SwiftData
import SwiftUI

struct AddPhoto: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var name: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            if let photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)

            }

            Divider()
            PhotosPicker(
                selection: $selectedPhoto,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Label("Seleccionar imagen", systemImage: "photo")
            }

            if photoData != nil {
                TextField("Nombre", text: $name).textFieldStyle(.roundedBorder)

                Button {
                    withAnimation {
                        let newImage = Photo(image: photoData, name: name)
                        modelContext.insert(newImage)
                        dismiss()
                    }
                } label: {
                    Text("Guardar Imagen")
                }

                Button {
                    withAnimation {
                        selectedPhoto = nil
                        photoData = nil
                    }
                } label: {
                    Text("Eliminar imagen")
                }.tint(.red)
                Spacer()
            }
        }.navigationTitle("Agregar Imagen")
            .padding(.all)
            .task(id: selectedPhoto) {
                if let data = try? await selectedPhoto?.loadTransferable(
                    type: Data.self
                ) {
                    photoData = data
                }
            }
    }
}
