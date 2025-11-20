//
//  ShareSheet.swift
//  NovedadesIOS16
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {

    var items: [Any]
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )

        return view
    }

    func updateUIViewController(
        _ uiViewController: UIViewControllerType,
        context: Context
    ) {

    }

}
