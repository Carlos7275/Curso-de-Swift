//
//  ReturnRoot.swift
//  NavegacionSwiftUI4
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 19/11/25.
//
import Combine
import SwiftUI

class ReturnRoot: ObservableObject {
    @Published var path = NavigationPath()

    func root() {
        path.removeLast(path.count)
    }
    
}
