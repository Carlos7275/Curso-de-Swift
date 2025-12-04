//
//  Export.swift
//  SwiftData-ImportExport
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/12/25.
//

import CoreTransferable
import Foundation
import UniformTypeIdentifiers

struct Export: Identifiable, Codable {
    var id: String
    var nombre: String
    var imc: String

}

struct Transactions: Codable, Transferable {
    var results: [Export]
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .extensionType)
            .suggestedFileName("Datos: \(Date())")
    }
}
extension UTType {
    static var extensionType = UTType(
        exportedAs: "com.carlos.SwiftData-ImportExport.jmb"
    )
}
