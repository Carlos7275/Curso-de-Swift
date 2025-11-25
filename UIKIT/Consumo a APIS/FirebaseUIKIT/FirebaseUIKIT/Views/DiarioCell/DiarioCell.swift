import UIKit

class DiarioCell: UITableViewCell {
    let favButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupFavButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFavButton()
    }

    private func setupFavButton() {
        contentView.addSubview(favButton)
        favButton.translatesAutoresizingMaskIntoConstraints = false

        favButton.tintColor = .systemYellow

        NSLayoutConstraint.activate([
            favButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -30
            ),
            favButton.widthAnchor.constraint(equalToConstant: 30),
            favButton.heightAnchor.constraint(equalToConstant: 30),
            favButton.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor
            ),
        ])
    }
}
