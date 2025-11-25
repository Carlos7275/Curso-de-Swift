//
//  EmptyLabel.swift
//  JsonMovies
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 21/11/25.
//

import UIKit

let emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "No se encontraron resultados"
    label.textAlignment = .center
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    label.isHidden = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}()
