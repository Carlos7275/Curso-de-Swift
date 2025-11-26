//
//  MessageView.swift
//  ChatAPP
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import SwiftUI

struct MessageView: View {
    var message: Messages
    @State private var bubble: Bool = false

    var headerDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"

        if Calendar.current.isDateInToday(message.timestamp) {
            return "Hoy"
        } else {
            return formatter.string(from: message.timestamp)
        }
    }

    // Hora tipo "11:34 AM"
    var messageTimeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: message.timestamp)
    }

    var body: some View {
        VStack(
            alignment: bubble ? .trailing : .leading,
            spacing: 4
        ) {

            Text(headerDateString)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom, 4)

            HStack {
                Text(message.text)
                    .foregroundColor(bubble ? .white : .black)
                    .padding(.vertical, 17)
                    .padding(.horizontal, 22)
                    .background(bubble ? Color.blue : Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .overlay(
                        Text(messageTimeString)
                            .font(.caption2)
                            .foregroundColor(bubble ? .white.opacity(0.8) : .gray)
                            .padding(.trailing, 12)
                            .padding(.bottom, 3),
                        alignment: .bottomTrailing
                    )
            }
            .frame(maxWidth: 300, alignment: bubble ? .trailing : .leading)

            // Nombre de usuario
            Text(message.username)
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(bubble ? .trailing : .leading, 25)
        }
        .frame(maxWidth: .infinity, alignment: bubble ? .trailing : .leading)
        .padding(bubble ? .trailing : .leading)
        .padding(.horizontal, 10)
        .onAppear {
            bubble = UserDefaults.standard.string(forKey: "idUser") == message.idUser
        }
    }
}
