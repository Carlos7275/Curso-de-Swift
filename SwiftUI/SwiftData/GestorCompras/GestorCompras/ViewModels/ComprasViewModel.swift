//
//  ListViewModel.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 28/11/25.
//
import Combine
import SwiftData
import SwiftUI

class ComprasViewModel: ObservableObject {
    @Published var list = Compras()
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false

    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func guardarDatos() {
        do {
            context.insert(list)
            try context.save()

        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }

    }
    func modificarDatos(for item: Compras) {
        do {
            self.list = item
            try context.save()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func eliminarDato(item: Compras) {
        do {
            context.delete(item)
            try context.save()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

}
