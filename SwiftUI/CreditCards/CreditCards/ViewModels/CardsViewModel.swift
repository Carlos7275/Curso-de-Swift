//
//  CardsViewModel.swift
//  CreditCards
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 21/11/25.
//

import Combine
import CoreData
import Foundation

class CardsViewModel: ObservableObject {

    @Published var errorMessage: String? = nil

    @Published var name: String = ""
    @Published var credit: String = ""
    @Published var type: String = ""
    @Published var number: String = ""

    private let cardsRepository: CoreDataRepository<Cards>

    init(context: NSManagedObjectContext) {
        self.cardsRepository = CoreDataRepository<Cards>(
            modelName: "CreditCards"
        )
        self.cardsRepository.setContext(context)
    }

    func guardarCard() {
        do {
            let card = try cardsRepository.create()
            card.id = UUID()
            card.name = name
            card.type = type
            card.credit = Int16(credit) ?? 0
            card.number = number
            try cardsRepository.save()

        } catch let error as NSError {
            errorMessage = error.localizedDescription
        }
    }

    func modificarCard(card: Cards) {
        do {
            card.name = name
            card.credit = Int16(credit) ?? 0
            card.type = type
            card.number = number

            try cardsRepository.save()

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func eliminarCard(card: Cards) {
        do {
            try cardsRepository.delete(card)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
   

}
