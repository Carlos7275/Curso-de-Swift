//
//  Home.swift
//  Notas
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/11/25.
//

import CoreData
import SwiftUI

struct Home: View {
    @StateObject var notaModel = NotaViewModel()
    @Environment(\.managedObjectContext) var context

    @FetchRequest(
        entity: Notas.entity(),
        sortDescriptors: [NSSortDescriptor(key: "fecha", ascending: true)],
        animation: .spring()
    )

    //    @FetchRequest(
    //        entity: Notas.entity(),
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Notas.fecha, ascending: true)],
    //        predicate: NSPredicate(format: "fecha >= %@", Date() as CVarArg),
    //        animation: .spring(),
    //    )
    var notas: FetchedResults<Notas>

    var body: some View {
        NavigationView {
            List {
                ForEach(notas) {
                    nota in
                    VStack(alignment: .leading) {
                        Text(nota.nota ?? "Sin notas").font(.title).bold()

                        Text(nota.fecha ?? Date(), style: .date)
                    }.contextMenu(
                        ContextMenu(menuItems: {
                            Button(action: {
                                notaModel.cargarNota(nota)
                            }) {
                                Label("Editar", systemImage: "pencil")
                            }

                            Button(action: {
                                notaModel.eliminarNota(nota, contexto: context)
                            }) {
                                Label("Eliminar", systemImage: "trash")
                            }
                        })
                    )
                }
            }.navigationTitle("Notas")
                .toolbar {
                    Button(action: {
                        notaModel.mostrarFormulario.toggle()
                    }) {
                        Image(systemName: "plus").font(.title)
                            .foregroundColor(.blue)
                    }.sheet(
                        isPresented: $notaModel.mostrarFormulario,
                        content: {
                            AddView(notaModel: notaModel)
                        }
                    )
                }

        }
        .alert(isPresented: $notaModel.mostrarAlerta) {
            Alert(
                title: Text("Ocurrió un error"),
                message: Text(notaModel.mensajeError),
                dismissButton: .default(Text("Aceptar"))
            )
        }

    }
}
