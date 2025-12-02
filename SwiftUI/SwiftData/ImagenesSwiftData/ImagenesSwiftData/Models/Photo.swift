//
//  Photo.swift
//  ImagenesSwiftData
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import Foundation
import SwiftData

@Model
class Photo {
    @Attribute(.externalStorage) var image:Data?
    var name : String
    
    init(image: Data? = nil, name: String) {
        self.image = image
        self.name = name
    }
}
