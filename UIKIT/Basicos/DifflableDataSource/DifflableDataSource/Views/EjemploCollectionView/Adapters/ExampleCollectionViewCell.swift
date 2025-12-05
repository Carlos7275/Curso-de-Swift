//
//  ExampleCollectionViewCell.swift
//  DifflableDataSource
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/12/25.
//

import UIKit

class ExampleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(message: String, image: String) {
        lblMessage.text = message
        img.image = UIImage(systemName: image)
    }

}
