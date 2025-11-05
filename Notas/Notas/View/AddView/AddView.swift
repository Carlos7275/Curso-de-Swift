//
//  AddView.swift
//  Notas
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/11/25.
//

import Combine
import SwiftUI

struct AddView: View {
    @ObservedObject var notaModel: NotaViewModel
    @Environment(\.managedObjectContext) var context

    var body: some View {

        VStack {
            Text(
                notaModel.notaSeleccionada == nil
                    ? "Agregar Nota" : "Editar Nota"
            )
            .font(.largeTitle)
            .bold()
            Spacer()
            TextEditor(text: $notaModel.textoNota)
            Divider()
            DatePicker("Seleccionar Fecha", selection: $notaModel.fechaNota)
            Spacer()
            Button(action: {
                if notaModel.notaSeleccionada == nil {
                    notaModel.agregarNota(contexto: context)
                } else {
                    notaModel.actualizarNota(contexto: context)
                }
            }) {
                Label(
                    title: { Text("Guardar").foregroundColor(.white) },
                    icon: {
                        Image(systemName: "plus").foregroundColor(.white)
                    }
                )

            }.padding()
                .frame(width: UIScreen.main.bounds.width - 30)
                .cornerRadius(10)
                .background(
                    notaModel.textoNota.isEmpty ? Color.gray : Color.blue
                )
                .disabled(
                    notaModel.textoNota.isEmpty
                        ? true : false
                )
        }.padding()

    }
}
