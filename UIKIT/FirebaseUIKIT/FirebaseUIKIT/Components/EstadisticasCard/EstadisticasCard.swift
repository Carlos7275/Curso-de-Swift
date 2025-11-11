import UIKit

@IBDesignable
@objc(EstadisticasCard)
class EstadisticasCard: UIView {

    // MARK: - Estilos
    @IBInspectable var cornerRadius: CGFloat = 12 { didSet { updateAppearance() } }
    @IBInspectable var shadowColor: UIColor = .gray { didSet { updateAppearance() } }
    @IBInspectable var shadowOpacity: Float = 0.3 { didSet { updateAppearance() } }
    @IBInspectable var shadowRadius: CGFloat = 6 { didSet { updateAppearance() } }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 3) { didSet { updateAppearance() } }
    @IBInspectable var borderWidth: CGFloat = 1 { didSet { updateAppearance() } }

    // MARK: - Contenido
    @IBInspectable var title: String? {
        didSet { titleLabel.text = title }
    }

    @IBInspectable var total: String? {
        didSet { totalLabel.text = total }
    }

    @IBInspectable var icon: UIImage? {
        didSet { iconImageView.image = icon }
    }

    // MARK: - Subviews
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .label
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .secondaryLabel
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    private let totalLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 28)
        lbl.textColor = .label
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Init
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
    }

    // MARK: - Setup
    private func setupSubviews() {
        if !subviews.contains(iconImageView) {
            addSubview(iconImageView)
            addSubview(titleLabel)
            addSubview(totalLabel)

            NSLayoutConstraint.activate([
                iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
                iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                iconImageView.widthAnchor.constraint(equalToConstant: 28),
                iconImageView.heightAnchor.constraint(equalToConstant: 28),

                titleLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

                totalLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 8),
                totalLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
                totalLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
                totalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
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
