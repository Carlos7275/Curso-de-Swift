//
//  FieldValidator.swift
//  Constraints
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 31/10/25.
//
import UIKit

class FieldValidator {
    let field: UIView
    let rules: [FieldRule]
    var errorLabel: UILabel?

    init(field: UIView, rules: [FieldRule]) {
        self.field = field
        self.rules = rules
    }
}
