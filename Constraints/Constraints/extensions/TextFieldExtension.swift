//
//  TextFieldExtension.swift
//  Constraints
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 31/10/25.
//
import UIKit

extension UITextField {
    func setIcon(_ image: UIImage, padding: CGFloat = 10) {
        let iconSize: CGFloat = 20
        
        let iconView = UIImageView(frame: CGRect(x: padding, y: 0, width: iconSize, height: iconSize))
        iconView.image = image
        iconView.contentMode = .scaleAspectFit
        
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: iconSize + padding * 2, height: iconSize))
        
        iconView.center.y = iconContainerView.frame.height / 2
        
        iconContainerView.addSubview(iconView)
        
        leftView = iconContainerView
        leftViewMode = .always
    }
}

