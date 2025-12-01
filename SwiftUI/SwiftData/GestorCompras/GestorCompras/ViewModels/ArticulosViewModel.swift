//
//  ArticulosViewModel.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 01/12/25.
//

//
//  ListViewModel.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 28/11/25.
//
import Combine
import SwiftData
import SwiftUI

class ArticulosViewModel: ObservableObject {
    @Published var articulo = Articulos()
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
   

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func guardarDatos() {
        do {
            context.insert(articulo)
            try context.save()

        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

    }
    func modificarDatos(for item: Articulos) {
        do {
            self.articulo = item
            try context.save()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func eliminarDato(item: Articulos) {
        do {
            context.delete(item)
            try context.save()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

}
