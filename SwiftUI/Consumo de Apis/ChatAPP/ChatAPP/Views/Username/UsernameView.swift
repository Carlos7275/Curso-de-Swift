//
//  UsernameView.swift
//  ChatAPP
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import SwiftUI

struct UsernameView: View {
    @EnvironmentObject var messageViewModel: MessagesViewModel
    @State private var name: String = ""

    var body: some View {
        ZStack {
            VStack {
                Text("Chat app")
                    .foregroundStyle(Color.black)
                    .font(.largeTitle)
                    .bold()
                    .padding(.all, 30)

                TextField("Usuario:", text: $name).textFieldStyle(
                    .roundedBorder
                )

                Button {
                    UserDefaults.standard.set(name, forKey: "username")
                    UserDefaults.standard.set(
                        UUID().uuidString,
                        forKey: "idUser"
                    )
                    messageViewModel.showChatApp = true

                } label: {
                    Text("Ingresar")
                        .foregroundStyle(Color.white)
                        .font(.title2)
                        .bold()
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                    .padding(.top, 10)
                    .disabled(name == "")
                Spacer()
            }
        }
    }
}
