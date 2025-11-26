//
//  CarrouselViewCell.swift
//  onBoardReelsUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 25/11/25.
//

import UIKit

class CarrouselViewCell: UICollectionViewCell {

    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var imagen: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(descripcion: String, image: String) {
        self.descripcion.text = descripcion
        self.descripcion.textAlignment = .center
        self.descripcion.textColor = .secondaryLabel
        imagen.image = UIImage(systemName: image)
        imagen.contentMode = .scaleAspectFit
    }

}
