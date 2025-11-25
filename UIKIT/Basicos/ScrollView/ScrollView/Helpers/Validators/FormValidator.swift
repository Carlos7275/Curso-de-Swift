import UIKit

class FormValidator: NSObject {

    private var fields: [FieldValidator] = []

    func register(field: UIView, rules: [FieldRule]) {
        let validation = FieldValidator(field: field, rules: rules)
        fields.append(validation)

        // Crear error label
        let errorLabel = UILabel()
        errorLabel.textColor = .red
        errorLabel.font = UIFont.systemFont(ofSize: 12)
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        field.superview?.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 2),
            errorLabel.leadingAnchor.constraint(equalTo: field.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: field.trailingAnchor)
        ])

        validation.errorLabel = errorLabel

        // UITextField
        if let textField = field as? UITextField {
            textField.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        }

        // UITextView
        if let textView = field as? UITextView {
            textView.delegate = self
        }
    }

    @objc private func textChanged(_ sender: UITextField) {
        _ = validateField(sender)
    }

    @discardableResult
    func validateField(_ field: UIView) -> Bool {
        guard let validation = fields.first(where: { $0.field === field }) else { return true }

        for rule in validation.rules {
            if let errorMessage = rule.rule(field) {
                // Aplica estilo según tipo
                if let textField = field as? UITextField {
                    textField.layer.borderColor = UIColor.red.cgColor
                    textField.layer.borderWidth = 1
                    textField.layer.cornerRadius = 5
                }
                if let textView = field as? UITextView {
                    textView.layer.borderColor = UIColor.red.cgColor
                    textView.layer.borderWidth = 1
                    textView.layer.cornerRadius = 5
                }
                validation.errorLabel?.text = errorMessage
                return false
            }
        }

        // Limpiar errores
        if let textField = field as? UITextField {
            textField.layer.borderWidth = 0
        }
        if let textView = field as? UITextView {
            textView.layer.borderWidth = 0
        }
        validation.errorLabel?.text = ""
        return true
    }

    func validateAll() -> Bool {
        return fields.allSatisfy { validateField($0.field) }
    }
}

// MARK: - UITextViewDelegate
extension FormValidator: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        _ = validateField(textView)
    }
}
