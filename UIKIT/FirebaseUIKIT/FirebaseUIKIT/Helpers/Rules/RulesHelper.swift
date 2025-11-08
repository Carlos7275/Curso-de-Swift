//
//  RulesHelper.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 07/11/25.
//

import UIKit


let required = FieldRule { view in
    if let textField = view as? UITextField {
        return (textField.text ?? "").isEmpty ? "Este campo es requerido" : nil
    }
    return nil
}

let isNumber = FieldRule { view in
    if let textField = view as? UITextField, let text = textField.text, !text.isEmpty {
        return Double(text) == nil ? "Debe ser un numero" : nil
    }
    return nil
}

let isDecimal = FieldRule { view in
    if let textField = view as? UITextField, let text = textField.text, !text.isEmpty {
        guard let _ = Double(text) else { return "Debe ser un numero" }
        let parts = text.split(separator: ".")
        return parts.count == 1 || parts.last!.count <= 2 ? nil : "Al menos debe tener dos decimales."
    }
    return nil
}

let maxLength = { (length: Int) -> FieldRule in
    return FieldRule { view in
        if let textField = view as? UITextField, let text = textField.text {
            return text.count > length ? "Máximo \(length) cáracteres" : nil
        }
        return nil
    }
}

let minLength = { (length: Int) -> FieldRule in
    return FieldRule { view in
        if let textField = view as? UITextField, let text = textField.text {
            return text.count < length ? "Minimo \(length) cáracteres" : nil
        }
        return nil
    }
}



func validBirthday(minAge: Int = 18, maxAge: Int = 120) -> FieldRule {
    return FieldRule { view in
        if let datePicker = view as? UIDatePicker {
            let today = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: datePicker.date, to: today)
            guard let age = ageComponents.year else { return "Fecha inválida" }
            if age < minAge || age > maxAge {
                return "Edad Minima entre \(minAge) a \(maxAge)"
            }
        }
        return nil
    }
}

func validEmail(message: String = "Ingresa un correo válido") -> FieldRule {
    return FieldRule { view in
        guard let textField = view as? UITextField else { return nil }
        let email = textField.text ?? ""
        
        let regex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        if predicate.evaluate(with: email) {
            return nil // ✅ es válido
        } else {
            return message // o
        }
    }
}

func validPassword(message: String = "La contraseña debe tener mínimo 8 caracteres, una mayúscula, una minúscula y un número") -> FieldRule {
    return FieldRule { view in
        guard let textField = view as? UITextField else { return nil }
        let password = textField.text ?? ""
        
        // Expresión regular para:
        // - (?=.*[a-z])  Minúscula
        // - (?=.*[A-Z])  Mayúscula
        // - (?=.*\\d)    Número
        // - .{8,}        Minimo 8 caracteres
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        
        return predicate.evaluate(with: password) ? nil : message
    }
}

