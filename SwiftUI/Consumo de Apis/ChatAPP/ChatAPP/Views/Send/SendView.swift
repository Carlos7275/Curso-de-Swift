//
//  SendView.swift
//  ChatAPP
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import SwiftUI

struct SendView: View {
    @StateObject var messageViewModel = MessagesViewModel()
    @State private var message: String = ""
    var body: some View {
        HStack {
            TextField("Ingrese su mensaje", text: $message).textFieldStyle(
                .roundedBorder
            )
            
            Button {
                messageViewModel.enviarMensaje(mensaje: message)
                message = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(Color.white)
                    .padding(10)
                    .background(.blue)
                    .clipShape(.circle)
            }.disabled(message == "")
        }
        .padding(.horizontal)
        .padding(.all)
        .alert("Error", isPresented: $messageViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(messageViewModel.errorMessage ?? "Ha ocurrido un error inesperado.")
        }
    }
}
