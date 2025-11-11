import UIKit

@IBDesignable
class CardView: UIView {

    // MARK: - Propiedades de estilo
    @IBInspectable var cornerRadius: CGFloat = 12
    @IBInspectable var shadowColor: UIColor = .gray
    @IBInspectable var shadowOpacity: Float = 0.3
    @IBInspectable var shadowRadius: CGFloat = 6
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 3)
    @IBInspectable var borderWidth: CGFloat = 1

    // MARK: - Título opcional
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
            let ocultar = title?.isEmpty ?? true
            titleLabel.isHidden = ocultar
            divider.isHidden = ocultar
        }
    }

    // MARK: - Subviews internos
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.isHidden = true
        return lbl
    }()

     let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // MARK: - Inicializadores
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setupCard()
        setupTitle()
    }

    // MARK: - Layout y diseño
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCard()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupCard()
        setupTitle()
    }

    private func setupCard() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false

        // Sombra
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
        let rect = bounds.width > 0 && bounds.height > 0 ? bounds : CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath

        // Borde completo como sublayer
        if let borderLayer = layer.sublayers?.first(where: { $0.name == "borderLayer" }) {
            borderLayer.removeFromSuperlayer()
        }
        let border = CAShapeLayer()
        border.name = "borderLayer"
        border.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        border.fillColor = UIColor.clear.cgColor
        border.strokeColor = UIColor.systemGray4.cgColor
        border.lineWidth = borderWidth
        layer.addSublayer(border)
    }

    // MARK: - Configurar título y línea divisoria
    private func setupTitle() {
        guard !subviews.contains(titleLabel) else { return }

        addSubview(titleLabel)
        addSubview(divider)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            divider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
