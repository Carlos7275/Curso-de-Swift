//
//  ChatView.swift
//  ChatAPP
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @State private var username: String = ""
    var body: some View {
        NavigationStack {
            VStack {
                if messagesViewModel.loading {
                    ProgressView()
                } else {

                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(messagesViewModel.messages) {
                                message in
                                MessageView(message: message)
                            }
                        }.padding(.top, 10)
                            .onChange(of: messagesViewModel.lastId) {
                                _,
                                id in
                                withAnimation {
                                    proxy.scrollTo(id, anchor: .bottom)
                                }
                            }

                    }

                    SendView()
                }
            }.navigationTitle(username)
                .toolbar {
                    Button("Salir") {
                        DispatchQueue.main.async {
                            UserDefaults.standard.removeObject(
                                forKey: "username"
                            )
                            UserDefaults.standard.removeObject(forKey: "idUser")
                            messagesViewModel.showChatApp = false
                        }
                    }

                }.onAppear {
                    username =
                        UserDefaults.standard.string(forKey: "username")
                        ?? "Usuario"
                }
        }.alert("Error", isPresented: $messagesViewModel.showError) {
            Button("OK", role: .cancel) {}

        } message: {
            Text(
                messagesViewModel.errorMessage
                    ?? "Ha ocurrido un error inesperado."
            )
        }
    }

}
