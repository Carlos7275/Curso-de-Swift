//
//  EmptyView.swift
//  DifflableDataSource
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/12/25.
//
import UIKit

// Vista de "No hay datos"
 let emptyView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 10

    let imageView = UIImageView(image: UIImage(systemName: "tray"))
    imageView.tintColor = .gray
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true

    let label = UILabel()
    label.text = "No hay datos"
    label.textColor = .gray
    label.font = .systemFont(ofSize: 18, weight: .medium)

    stack.addArrangedSubview(imageView)
    stack.addArrangedSubview(label)

    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
}()
