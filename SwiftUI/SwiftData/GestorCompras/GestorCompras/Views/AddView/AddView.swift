//
//  AddView.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 28/11/25.
//

import Combine
import SwiftData
import SwiftUI

struct AddView: View {
    @StateObject var listViewModel: ComprasViewModel
    @Environment(\.dismiss) var dismiss

    @State private var errorTitulo: String = ""
    @State private var errorPresupuesto: String = ""

    init(context: ModelContext) {
        _listViewModel = StateObject(
            wrappedValue: ComprasViewModel(context: context)
        )
    }

    var body: some View {
        List {
            TextField("Titulo", text: $listViewModel.list.titulo)
                .autocorrectionDisabled()
                .onChange(of: listViewModel.list.titulo) { _, _ in
                    validarNombre()
                }

            if !errorTitulo.isEmpty {
                Text(errorTitulo)
                    .foregroundColor(.red)
            }

            TextField(
                "Presupuesto",
                value: $listViewModel.list.presupuesto,
                format: .number
            ).keyboardType(.decimalPad)
                .onChange(of: listViewModel.list.presupuesto) { _, _ in
                    validarPresupuesto()
                }

            if !errorPresupuesto.isEmpty {
                Text(errorPresupuesto)
                    .foregroundStyle(.red)
            }

            DatePicker("Fecha", selection: $listViewModel.list.fecha)

            Button {
                withAnimation {
                    if validarCampos() {
                        listViewModel.guardarDatos()
                        dismiss()

                    }
                }
            } label: {
                Text("Guardar")
            }
            .navigationTitle("Crear Compra")
        }
    }

    private func validarCampos() -> Bool {
        validarNombre()
        validarPresupuesto()

        return errorTitulo.isEmpty && errorPresupuesto.isEmpty
    }

    private func validarNombre() {

        errorTitulo = ""

        if (listViewModel.list.titulo.trimmingCharacters(in: .whitespaces))
            .isEmpty
        {
            errorTitulo = "El titulo no puede estar vácio"
        }
    }

    private func validarPresupuesto() {
        if listViewModel.list.presupuesto <= 0 {
            errorPresupuesto = "El presupuesto debe ser mayor a 0"
        }
    }
}
