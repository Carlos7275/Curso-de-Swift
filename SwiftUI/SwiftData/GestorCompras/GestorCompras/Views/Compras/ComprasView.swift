//
//  ComprasView.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 01/12/25.
//

import SwiftData
import SwiftUI

struct ComprasView: View {
    @Bindable var itemList: Compras

    @Environment(\.dismiss) var dismiss
    @State private var nombreArticulo: String = ""
    @State private var precioArticulo: String = ""
    @State private var cantidadArticulo: Int = 1

    ///Errores de validación en los inputs
    @State private var errorNombreArticulo: String = ""
    @State private var errorPrecioArticulo: String = ""

    @FocusState private var isFocus: Bool

    @StateObject var articulosViewModel: ArticulosViewModel

    @Query private var articulos: [Articulos]

    var precioFinal: Double {
        articulos.filter { $0.idCompra.contains(itemList.id) }.reduce(
            0.0,
            {
                $0 + $1.precio
            }
        )
    }

    init(itemList: Compras, context: ModelContext) {
        self.itemList = itemList
        _articulosViewModel = StateObject(
            wrappedValue: ArticulosViewModel(context: context)
        )

    }

    var body: some View {
        VStack {

            VStack {
                TextField("Articulo", text: $nombreArticulo).textFieldStyle(
                    .roundedBorder
                )
                .onChange(
                    of: nombreArticulo,
                    { _, _ in
                        validarNombre()
                    }
                )
                .focused($isFocus)

                if !errorNombreArticulo.isEmpty {
                    Text(errorNombreArticulo).foregroundStyle(.red).font(
                        .caption
                    )
                }

                VStack {
                    TextField("Precio", text: $precioArticulo)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: precioArticulo) { _, _ in
                            validarPrecio()

                        }

                    if !errorPrecioArticulo.isEmpty {
                        Text(errorPrecioArticulo).foregroundStyle(.red).font(
                            .caption
                        )
                    }
                    Spacer()
                    Stepper(
                        "Cantidad: \(cantidadArticulo)",
                        value: $cantidadArticulo,
                        in: 1...100
                    )
                }

                Button {

                    if validarCampos() {
                        let precioTotal =
                            (Double(precioArticulo) ?? 0)
                            * Double(cantidadArticulo)

                        let articulo = Articulos(
                            articulo: nombreArticulo,
                            precio: precioTotal,
                            idCompra: itemList.id
                        )
                        itemList.relationArticulos.append(articulo)

                        articulosViewModel.articulo = articulo
                        articulosViewModel.guardarDatos()

                        //Limpiar datos

                        isFocus = true
                        nombreArticulo = ""
                        precioArticulo = ""
                        cantidadArticulo = 1

                        let updatePresupuesto =
                            (Double(itemList.presupuesto)) - precioTotal
                        itemList.presupuesto = updatePresupuesto
                    }

                } label: {
                    Text("Agregar")
                }
                Spacer()
                Text(
                    "Presupuesto : $\(String(format:"%.2f",itemList.presupuesto))"
                ).bold()

            }
            .padding(.all)

            List {
                Section("Carrito") {
                    ForEach(
                        articulos.filter { $0.idCompra.contains(itemList.id) }
                    ) { item in
                        HStack {
                            Text(item.articulo)
                            Spacer()
                            Text("$\(item.precio.formatted())").swipeActions {
                                Button(role: .destructive) {
                                    let sumaPre =
                                        (Double(itemList.presupuesto))
                                        + item.precio
                                    itemList.presupuesto = sumaPre
                                    articulosViewModel.eliminarDato(item: item)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }

                    }
                    HStack {
                        Text("Total:").bold()
                        Spacer()
                        Text("$\(precioFinal.formatted())").bold()
                    }
                }
            }
        }.navigationTitle(itemList.titulo)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button {
                        itemList.completado = true
                        itemList.total = precioFinal
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
    }

    private func validarNombre() {
        errorNombreArticulo = ""

        if nombreArticulo.trimmingCharacters(in: .whitespaces).isEmpty {
            errorNombreArticulo = "Ingrese el nombre del articulo"
        }
    }

    private func validarPrecio() {
        errorPrecioArticulo = ""

        if precioArticulo.isEmpty || Double(precioArticulo) == nil {
            errorPrecioArticulo = "Ingrese un precio válido"
        } else if Double(precioArticulo)! > itemList.presupuesto {
            errorPrecioArticulo = "El precio supera el presupuesto"
        }
    }
    
    private func validarCampos() -> Bool {
        validarNombre()
        validarPrecio()

        return errorNombreArticulo.isEmpty &&
               errorPrecioArticulo.isEmpty
    }

}
