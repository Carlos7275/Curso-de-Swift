//
//  Messages.swift
//  ChatAPP
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import Foundation

struct Messages: Identifiable, Codable {
    var id: String
    var text: String
    var username: String
    var idUser: String
    var timestamp: Date
}
