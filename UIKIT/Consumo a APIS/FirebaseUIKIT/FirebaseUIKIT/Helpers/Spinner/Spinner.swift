//
//  Spinner.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 07/11/25.
//

import UIKit

// MARK: - Spinner
let spinner: UIActivityIndicatorView = {
    let sp = UIActivityIndicatorView(style: .large)
    sp.color = .gray
    sp.hidesWhenStopped = true
    sp.translatesAutoresizingMaskIntoConstraints = false
    return sp
}()
