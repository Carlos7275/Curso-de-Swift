//
//  DecimalTextFieldValidator.swift
//  Constraints
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 31/10/25.
//

import UIKit

struct TextFieldValidator {
    static func allowDecimalInput(currentText: String?, replacementString string: String) -> Bool {
        let allowedCharacters = "0123456789."
        let characterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        
        if !characterSet.isSuperset(of: typedCharacterSet) {
            return false
        }
        
        if let text = currentText, text.contains("."), string.contains(".") {
            return false
        }
        
        return true
    }
}
