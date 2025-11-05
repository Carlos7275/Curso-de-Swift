import UIKit


let required = FieldRule { view in
    if let textField = view as? UITextField {
        return (textField.text ?? "").isEmpty ? "This field is required" : nil
    }
    return nil
}

let isNumber = FieldRule { view in
    if let textField = view as? UITextField, let text = textField.text, !text.isEmpty {
        return Double(text) == nil ? "Must be a number" : nil
    }
    return nil
}

let isDecimal = FieldRule { view in
    if let textField = view as? UITextField, let text = textField.text, !text.isEmpty {
        guard let _ = Double(text) else { return "Must be a number" }
        let parts = text.split(separator: ".")
        return parts.count == 1 || parts.last!.count <= 2 ? nil : "Must have at most 2 decimals"
    }
    return nil
}

let maxLength = { (length: Int) -> FieldRule in
    return FieldRule { view in
        if let textField = view as? UITextField, let text = textField.text {
            return text.count > length ? "Max \(length) characters" : nil
        }
        return nil
    }
}

let minLength = { (length: Int) -> FieldRule in
    return FieldRule { view in
        if let textField = view as? UITextField, let text = textField.text {
            return text.count < length ? "Min \(length) characters" : nil
        }
        return nil
    }
}


let validHeight = FieldRule { view in
    if let textField = view as? UITextField, let text = textField.text, let value = Double(text) {
        if value < 0.5 || value > 2.5 {
            return "Height must be between 0.5 and 2.5 meters"
        }
        let parts = text.split(separator: ".")
        if parts.count == 2 && parts.last!.count > 2 {
            return "Height can have at most 2 decimals"
        }
    } else {
        return "Must be a number"
    }
    return nil
}


func validBirthday(minAge: Int = 18, maxAge: Int = 120) -> FieldRule {
    return FieldRule { view in
        if let datePicker = view as? UIDatePicker {
            let today = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: datePicker.date, to: today)
            guard let age = ageComponents.year else { return "Invalid date" }
            if age < minAge || age > maxAge {
                return "Age must be between \(minAge) and \(maxAge)"
            }
        }
        return nil
    }
}
