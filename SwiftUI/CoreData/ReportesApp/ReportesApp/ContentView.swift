//
//  ContentView.swift
//  ReportesApp
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 27/11/25.
//

import CoreData
import SwiftUI
internal import UniformTypeIdentifiers

struct ContentView: View {
    private var viewContext: NSManagedObjectContext
    @StateObject private var imp: UtilData
    @State private var showPicker: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    @FetchRequest(
        entity: Autos.entity(),
        sortDescriptors: []
    ) var autos: FetchedResults<Autos>

    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        _imp = StateObject(wrappedValue: UtilData(context: viewContext))
    }

    var body: some View {
        NavigationStack {
            VStack {

                // LISTA DE AUTOS
                if autos.isEmpty {
                    Text("No hay autos registrados.")
                        .padding()
                        .foregroundStyle(.secondary)
                } else {
                    List(autos, id: \.self) { auto in
                        HStack {
                            Text(
                                "\(auto.marca ?? "N/A") • \(auto.modelo ?? "N/A") • \(auto.color ?? "N/A")"
                            )
                        }
                    }
                }

                // BOTÓN IMPORTAR
                Button {
                    showPicker = true
                } label: {
                    Text("Importar datos")
                        .padding(.top, 10)
                }
                .fileImporter(
                    isPresented: $showPicker,
                    allowedContentTypes: [.data],
                    allowsMultipleSelection: false
                ) { result in
                    do {
                        let urls = try result.get()
                        if let url = urls.first {
                            imp.importarDatosCSV(fileURL: url)
                        }
                    } catch let error as NSError {
                        errorMessage = error.localizedDescription
                        showError = true
                    }
                }

            }
            .navigationTitle("Importaciones/Exp CoreData")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        if let file = imp.exportarCSV() {
                            ShareLink("Exportar a CSV", item: file)
                        }

                        if let html = imp.exportarHTML() {
                            ShareLink("Exportar a HTML", item: html)
                        }

                        if let pdf = imp.exportarPDF() {
                            ShareLink("Exportar a PDF", item: pdf)
                        }

                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }

        // ALERTAS
        .alert("Error", isPresented: $imp.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(imp.errorMessage)
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }

        // OVERLAY DE LOADING
        .overlay {
            if imp.loading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()

                    ProgressView("Cargando…")
                        .padding(20)
                        .background(.ultraThinMaterial)
                        .cornerRadius(14)
                        .shadow(radius: 5)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: imp.loading)
    }
}
