//
//  DataView.swift
//  SwiftData-ImportExport
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/12/25.
//

import SwiftData
import SwiftUI

struct DataView: View {
    @Query private var items: [IMC]
    @Environment(\.modelContext) var context
    @State private var datos: [Export] = []
    @State private var importData: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            if items.isEmpty {
                ContentUnavailableView(
                    "No hay Datos registrados...",
                    systemImage: "list.clipboard"
                )
            } else {
                List {
                    ForEach(items) {
                        item in
                        VStack(alignment: .leading) {
                            Text(item.nombre).font(.title).bold()
                            Text(item.imc).font(.caption).bold()
                        }.onAppear {
                            let datosExport = Export(
                                id: item.id,
                                nombre: item.nombre,
                                imc: item.imc
                            )

                            datos.append(datosExport)

                        }
                        .swipeActions {
                            Button(
                                "Eliminar",
                                systemImage: "trash",
                                role: .destructive
                            ) {
                                withAnimation {
                                    context.delete(item)
                                }
                            }

                        }
                    }
                }
            }
        }

        .navigationTitle("Datos")
        .toolbar {
            HStack {
                ShareLink(
                    item: Transactions(results: datos),
                    preview: SharePreview("Share", image: "square.and.arrow.up")
                )
                Button("", systemImage: "square.and.arrow.down") {
                    importData.toggle()
                }
            }
        }.fileImporter(
            isPresented: $importData,
            allowedContentTypes: [.extensionType]
        ) {
            result in
            switch result {
            case .success(let url):
                do {
                    let data = try Data(contentsOf: url)
                    let datosImport = try JSONDecoder().decode(
                        Transactions.self,
                        from: data
                    )

                    for dato in datosImport.results {
                        if let idExist = datos.firstIndex(where: {
                            $0.id == dato.id
                        }) {
                            alertMessage =
                                "Ya existe un registro con el mismo ID \(idExist)"
                            showAlert = true
                        } else {
                            context.insert(
                                IMC(
                                    id: dato.id,
                                    nombre: dato.nombre,
                                    imc: dato.imc
                                )
                            )
                        }

                    }

                } catch {
                    alertMessage = error.localizedDescription
                    showAlert = true
                }
            case .failure(let failure):
                alertMessage = failure.localizedDescription
                showAlert = true
            }
        }.alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
            }
        } message: {
            Text(alertMessage)
        }
    }
}
