//
//  Overlay.swift
//  ScrollView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import Foundation
import UIKit


let overlay: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    v.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    v.isHidden = true
    return v
}()
