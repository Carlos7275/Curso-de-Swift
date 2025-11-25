//
//  CardType.swift
//  CreditCards
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 24/11/25.
//

import SwiftUI

enum CardType: String, CaseIterable, Identifiable {
    case visa = "VISA"
    case mastercard = "MASTER CARD"
    case amex = "AMERICAN EXPRESS"

    var id: String { self.rawValue }

    var gradient: [Color] {
        switch self {
        case .visa:
            return [Color.hex("#1434CB"), Color.hex("#2A52BE")]
        case .mastercard:
            return [Color.hex("#FF5F00"), Color.hex("#EB001B")]
        case .amex:
            return [Color.hex("#4DB7E6"), Color.hex("#0077A6")]
        }
    }


    static func from(_ string: String) -> CardType {
        return CardType(rawValue: string.uppercased()) ?? .visa
    }

}
