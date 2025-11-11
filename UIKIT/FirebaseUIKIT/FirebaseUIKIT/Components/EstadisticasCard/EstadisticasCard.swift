import UIKit

@IBDesignable
class EstadisticasCard: CardView {

    // MARK: - Icono y número
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let numberLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textColor = .label
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Propiedades inspectables
    @IBInspectable var icon: UIImage? {
        didSet {
            iconImageView.image = icon?.withRenderingMode(.alwaysTemplate)
        }
    }

    @IBInspectable var numberText: String? {
        didSet {
            numberLabel.text = numberText
        }
    }

    @IBInspectable var iconTintColor: UIColor = .systemBlue {
        didSet {
            iconImageView.tintColor = iconTintColor
        }
    }

    // MARK: - Inicialización
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStatCard()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStatCard()
    }

    private func setupStatCard() {

        // Agregar views al stack horizontal
        containerStack.addArrangedSubview(iconImageView)
        containerStack.addArrangedSubview(numberLabel)

        // Agregar stack a la vista
        addSubview(containerStack)

        // Aplicar tint inicial
        iconImageView.tintColor = iconTintColor

        NSLayoutConstraint.activate([
            // Centrar el stack bajo el título
            containerStack.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 12),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            containerStack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -12),

            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    // MARK: - Configuración rápida
    func configure(title: String, icon: UIImage?, number: String, tint: UIColor = .systemBlue) {
        self.title = title
        self.icon = icon
        self.numberText = number
        self.iconTintColor = tint
    }
}
