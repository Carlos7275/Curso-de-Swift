//
//  CardPhoto.swift
//  ImagenesSwiftData
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI

struct CardPhoto: View {
    var item: Photo

    var body: some View {
        if let photo = item.image, let uiImage = UIImage(data: photo) {
            VStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)

                Text(item.name).font(.title)
                    .bold()

            }.padding(.all)
                .background(Color(uiColor: .systemGroupedBackground))
        }
    }
}
