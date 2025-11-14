//
//  ContentView.swift
//  BookStore
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 12/11/25.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var tienda: Tienda

    var body: some View {
        NavigationView {
            List(tienda.libros, id: \.self) {
                libro in
                Group {
                    if !libro.bloqueo {
                        NavigationLink(destination: LibrosView()) {
                            LibroRow(libro: libro) {}
                        }
                    } else {
                        LibroRow(libro: libro) {
                            if let producto = tienda.producto(for: libro.id) {
                                tienda.comprarProducto(producto: producto)
                            }
                        }
                    }
                }
            }.navigationTitle("Tienda de libros")
                .toolbar {
                    Button("Restaurar Compra") {
                        tienda.restablecerCompra()
                    }
                }
        }
    }
}

struct LibroRow: View {
    let libro: Libros
    let acccion: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(libro.titulo).font(.title).bold()
                Text(libro.descripcion).font(.subheadline).bold()
                Spacer()

                if let precio = libro.precio, libro.bloqueo {
                    Button(action: acccion) {
                        Text(precio)
                    }
                }
            }
        }
    }
}
