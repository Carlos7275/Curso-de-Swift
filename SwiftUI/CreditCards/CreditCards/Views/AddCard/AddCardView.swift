//
//  AddCardView.swift
//  CreditCards
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 21/11/25.
//

import CoreData
import SwiftUI

struct AddCardView: View {

    var card: Cards?

    @StateObject var cardsViewModel: CardsViewModel
    @Environment(\.dismiss) var dismiss

    @State private var nameError = ""
    @State private var numberError = ""
    @State private var creditError = ""
    @State private var showSavedAlert: Bool = false
    @State private var isSaving: Bool = false

    var isFormValid: Bool {
        return nameError.isEmpty && numberError.isEmpty && creditError.isEmpty
            && !cardsViewModel.name.isEmpty && !cardsViewModel.number.isEmpty
            && !cardsViewModel.credit.isEmpty
    }

    let types = ["VISA", "MASTER CARD", "AMERICAN EXPRESS"]

    init(card: Cards, context: NSManagedObjectContext) {
        self.card = card
        _cardsViewModel = StateObject(
            wrappedValue: CardsViewModel(context: context)
        )
    }

    init(context: NSManagedObjectContext) {
        _cardsViewModel = StateObject(
            wrappedValue: CardsViewModel(context: context)
        )
    }
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {

                Text(card != nil ? "Edit Credit card" : "Add Credit card")
                    .font(.title)
                    .bold()

                CreditCardPreview(
                    data: PreviewCardData(
                        name: cardsViewModel.name,
                        number: cardsViewModel.number,
                        credit: Int16(cardsViewModel.credit) ?? 0,
                        type: CardType.from(cardsViewModel.type)
                    )
                ).padding(.all)

                Spacer()
                VStack(alignment: .leading) {
                    TextField("Name:", text: $cardsViewModel.name)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: cardsViewModel.name) { _, newValue in
                            nameError =
                                newValue.trimmingCharacters(in: .whitespaces)
                                    .isEmpty ? "Name cannot be empty" : ""
                        }
                    if !nameError.isEmpty {
                        Text(nameError).foregroundColor(.red).font(.caption)
                    }
                }

                VStack(alignment: .leading) {
                    TextField("Number:", text: $cardsViewModel.number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .onChange(of: cardsViewModel.number) { _, newValue in
                            // Filtrar solo dígitos
                            let digits = newValue.filter {
                                "0123456789".contains($0)
                            }

                            // Limitar a 16 dígitos máximo
                            let limitedDigits = String(digits.prefix(16))

                            // Formatear cada 4 dígitos
                            var formatted = ""
                            for (index, char) in limitedDigits.enumerated() {
                                if index != 0 && index % 4 == 0 {
                                    formatted += " "
                                }
                                formatted.append(char)
                            }

                            // Actualizar el número en el ViewModel
                            cardsViewModel.number = formatted

                            // Validación de longitud
                            let rawLength = limitedDigits.count
                            numberError =
                                (rawLength < 13 || rawLength > 16)
                                ? "Card number must be 13-16 digits" : ""
                        }
                    if !numberError.isEmpty {
                        Text(numberError).foregroundColor(.red).font(.caption)
                    }
                }

                VStack(alignment: .leading) {
                    TextField("Credit:", text: $cardsViewModel.credit)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .onChange(of: cardsViewModel.credit) { _, newValue in
                            let filtered = newValue.filter {
                                "0123456789".contains($0)
                            }
                            if filtered != newValue {
                                cardsViewModel.credit = filtered
                            }
                            creditError =
                                Int(filtered) ?? 0 <= 0
                                ? "Credit must be a positive number" : ""
                        }
                    if !creditError.isEmpty {
                        Text(creditError).foregroundColor(.red).font(.caption)
                    }
                }

                Picker("Tipo", selection: $cardsViewModel.type) {
                    ForEach(CardType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)

                Button {
                    if isFormValid {
                        isSaving = true

                        card != nil
                            ? cardsViewModel.modificarCard(card: card!)
                            : cardsViewModel.guardarCard()
                        showSavedAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            dismiss()
                        }
                    }

                } label: {
                    HStack {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Image(systemName: "plus")
                        }

                        Text(
                            isSaving
                                ? "Saving..."
                                : (card != nil ? "Edit card" : "Save card")
                        )
                        .font(.title3)
                        .bold()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .disabled(!isFormValid || isSaving)
                .opacity((isFormValid && !isSaving) ? 1 : 0.5)
                .disabled(!isFormValid)
                .opacity(isFormValid ? 1 : 0.5)
            }
        }
        .onAppear {
            if card != nil {
                cardsViewModel.name = card!.name ?? ""
                cardsViewModel.number = card!.number ?? ""
                cardsViewModel.credit = String(card!.credit)
                cardsViewModel.type = card!.type ?? ""
            }
        }
        .alert(isPresented: $showSavedAlert) {
            Alert(
                title: Text("Success"),
                message: Text(card != nil ? "Card updated!" : "Card saved!"),
                dismissButton: .default(Text("OK"))
            )
        }
        .padding()
        .presentationDetents([.height(600)])
    }
}
