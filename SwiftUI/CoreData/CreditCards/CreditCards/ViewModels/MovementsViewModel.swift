//
//  MovementsViewModel.swift
//  Creditmovements
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 24/11/25.
//

import Combine
import CoreData
import Foundation

class MovementsViewModel: ObservableObject {

    @Published var errorMessage: String? = nil

    @Published var name: String = ""
    @Published var mount: Double = 0.0
    @Published var date: Date = Date()

    private let movementsRepository: CoreDataRepository<Movements>

    init(context: NSManagedObjectContext) {
        self.movementsRepository = CoreDataRepository<Movements>(
            modelName: "CreditCards"
        )
        self.movementsRepository.setContext(context)
    }

    func guardarMovement(card: Cards) {
        do {
            let movement = try movementsRepository.create()
            movement.id = UUID()
            movement.name = name
            movement.price = NSDecimalNumber(value: mount)
            movement.idCard = card.id
            card.mutableSetValue(forKey: "relationToMovements").add(movement)

            movement.date = date
            try movementsRepository.save()

        } catch let error as NSError {
            errorMessage = error.localizedDescription
        }
    }

    func modificarMovement(movement: Movements) {
        do {
            movement.name = name
            movement.price = NSDecimalNumber(value: mount)
            movement.date = date

            try movementsRepository.save()

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func eliminarMovement(movement: Movements) {
        do {
            try movementsRepository.delete(movement)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

}
