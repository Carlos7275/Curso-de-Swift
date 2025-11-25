//
//  TextField.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 10/11/25.
//

import UIKit

extension UITextField {

    func setLeftIcon(_ systemName: String) {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: systemName)
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        let containerView = UIView(
            frame: CGRect(x: 0, y: 0, width: 34, height: 34)
        )
        containerView.addSubview(imageView)
        imageView.center = containerView.center

        self.leftView = containerView
        self.leftViewMode = .always
    }

}
