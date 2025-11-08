//
//  LoadingView.swift
//  PokeApiUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//
import UIKit

func loadingView(opacity: Double = 1.0) -> UIView {
    let view = UIView()
    view.backgroundColor = UIColor.systemBackground.withAlphaComponent(opacity)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}
