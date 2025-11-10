import UIKit

class PasswordField: UITextField {

    private let toggleButton: UIButton = {
        let button = UIButton(type: .system)

        // Ícono con tamaño definido (esto elimina pixelado)
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        button.setImage(UIImage(systemName: "eye.slash", withConfiguration: config), for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.isSecureTextEntry = true
        self.borderStyle = .roundedRect

        // Contenedor un poquito más ancho para respirar
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 32))
        toggleButton.frame = container.bounds.insetBy(dx: 4, dy: 4)

        container.addSubview(toggleButton)
        toggleButton.addTarget(self, action: #selector(togglePassword), for: .touchUpInside)

        self.rightView = container
        self.rightViewMode = .always
    }

    @objc private func togglePassword() {
        self.isSecureTextEntry.toggle()

        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let icon = self.isSecureTextEntry ? "eye.slash" : "eye"
        toggleButton.setImage(UIImage(systemName: icon, withConfiguration: config), for: .normal)

        // Fix cursor jump
        if let txt = self.text {
            self.text = ""
            self.text = txt
        }
    }
}
