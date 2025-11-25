//
//  Loading.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 10/11/25.
//


import UIKit

class Loading {
    private static var overlayView: UIView?

    static func show(on view: UIView) {
        // Evita que se muestre dos veces
        guard overlayView == nil else { return }
        
        let overlay = UIView(frame: view.bounds)
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.center = overlay.center
        spinner.startAnimating()

        overlay.addSubview(spinner)
        view.addSubview(overlay)

        overlayView = overlay
    }

    static func hide(from view: UIView) {
        overlayView?.removeFromSuperview()
        overlayView = nil
    }
}
