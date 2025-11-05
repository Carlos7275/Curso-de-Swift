import Combine
//
//  Columnas.swift
//  ListasGrids
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/11/25.
//
import Foundation
import SwiftUI

class Columnas: ObservableObject {
    @Published var gridItem = [GridItem()]

    init() {
        if let num = UserDefaults.standard.value(forKey: "columnas") as? Int {
            self.columnas(num: num)
        }
    }
    func columnas(num: Int) {

        gridItem = Array(repeating: .init(.flexible(maximum: 80)), count: num)
        UserDefaults.standard.set(num, forKey: "columnas")
    }

}
