import UIKit
@IBDesignable
@objc(CardView)
class CardView: UIView {

    // MARK: - Propiedades de estilo
    @IBInspectable var cornerRadius: CGFloat = 12 { didSet { updateAppearance() } }
    @IBInspectable var shadowColor: UIColor = .gray { didSet { updateAppearance() } }
    @IBInspectable var shadowOpacity: Float = 0.3 { didSet { updateAppearance() } }
    @IBInspectable var shadowRadius: CGFloat = 6 { didSet { updateAppearance() } }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 3) { didSet { updateAppearance() } }
    @IBInspectable var borderWidth: CGFloat = 1 { didSet { updateAppearance() } }

    @IBInspectable var titleFontSize: CGFloat = 18 {
        didSet {
            titleLabel.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        }
    }

    // MARK: - Título opcional
    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
            let ocultar = (title?.isEmpty ?? true)
            titleLabel.isHidden = ocultar
            divider.isHidden = ocultar
        }
    }

    // MARK: - Subviews internos
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 18) // valor por defecto
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
        setupSubviews()
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        updateAppearance()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupSubviews()
        updateAppearance()
        setNeedsLayout()
        layoutIfNeeded()
    }

    private func setupSubviews() {
        if !subviews.contains(titleLabel) {
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

    // MARK: - Apariencia
    private func updateAppearance() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false

        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset

        layer.sublayers?.removeAll(where: { $0.name == "borderLayer" })
        let border = CAShapeLayer()
        border.name = "borderLayer"
        border.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        border.fillColor = UIColor.clear.cgColor
        border.strokeColor = UIColor.systemGray4.cgColor
        border.lineWidth = borderWidth
        layer.insertSublayer(border, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateAppearance()
    }
}
