//
//  Spinner.swift
//  JsonMovies
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 20/11/25.
//
import UIKit

let spinner: UIActivityIndicatorView = {
    let spinner = UIActivityIndicatorView(style: .large)
    spinner.hidesWhenStopped = true
    spinner.color = .systemBlue
    spinner.translatesAutoresizingMaskIntoConstraints = false
    return spinner
}()
