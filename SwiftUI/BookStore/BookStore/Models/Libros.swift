//
//  Libros.swift
//  BookStore
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 14/11/25.
//

import Foundation
import StoreKit

struct Libros: Hashable {
    let id: String
    let titulo: String
    let descripcion: String
    var precio: String?
    var bloqueo: Bool = false
    let locale: Locale

    lazy var formatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = self.locale
        return nf
    }()

    init(product: SKProduct, bloqueo: Bool = true) {
        self.id = product.productIdentifier
        self.titulo = product.localizedTitle
        self.descripcion = product.localizedDescription
        self.bloqueo = bloqueo
        self.locale = product.priceLocale

        if bloqueo {
            self.precio = formatter.string(from: product.price)
        }

    }
}
