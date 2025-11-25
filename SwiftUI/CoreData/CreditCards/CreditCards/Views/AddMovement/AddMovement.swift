import CoreData
import SwiftUI

struct AddMovement: View {
    var card: Cards?
    var creditAvailable: Double
    @State private var movement: Movements?
    @StateObject private var movementsViewModel: MovementsViewModel
    @Environment(\.dismiss) var dismiss

    @State private var nameError = ""
    @State private var amountError = ""

    @State private var isProcessing = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var maxAllowedAmount: Double {
        if let mov = movement {
            // Sumamos el monto original de este movimiento al crédito disponible
            return creditAvailable + (mov.price?.doubleValue ?? 0)
        } else {
            return creditAvailable
        }
    }

    var isFormValid: Bool {
        return nameError.isEmpty && amountError.isEmpty
            && !movementsViewModel.name.trimmingCharacters(in: .whitespaces)
                .isEmpty
            && movementsViewModel.mount > 0
            && movementsViewModel.mount <= maxAllowedAmount
    }

    init(card: Cards, creditAvailable: Double, context: NSManagedObjectContext)
    {
        self.card = card
        self.creditAvailable = creditAvailable
        _movementsViewModel = StateObject(
            wrappedValue: MovementsViewModel(context: context)
        )
    }

    init(
        card: Cards,
        movement: Movements,
        creditAvailable: Double,
        context: NSManagedObjectContext
    ) {
        self.card = card
        self.movement = movement
        self.creditAvailable = creditAvailable

        _movementsViewModel = StateObject(
            wrappedValue: MovementsViewModel(context: context)
        )
    }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(movement != nil ? "Edit Movement" : "Add Movement")
                    .font(.title)
                    .bold()

                // Name Field
                TextField("Name of movement", text: $movementsViewModel.name)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: movementsViewModel.name) { _, newValue in
                        let trimmed = newValue.trimmingCharacters(
                            in: .whitespaces
                        )
                        nameError =
                            trimmed.isEmpty ? "Name cannot be empty" : ""
                    }

                if !nameError.isEmpty {
                    Text(nameError)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // Amount Field
                TextField(
                    "Amount",
                    value: $movementsViewModel.mount,
                    format: .number
                )
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .onChange(of: movementsViewModel.mount) { _, newValue in

                    if newValue > maxAllowedAmount {
                        amountError = "Not enough credit"
                    }
                    if newValue <= 0 {
                        amountError = "Price must be positive"
                    } else {
                        amountError = ""
                    }
                }

                if !amountError.isEmpty {
                    Text(amountError)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                // Date Picker
                DatePicker("Date", selection: $movementsViewModel.date)
                    .datePickerStyle(.compact)

                // Save Button
                Button {
                    guard isFormValid else { return }
                    isProcessing = true
                    Task {
                        if let mov = movement {
                            // Modify
                            movementsViewModel.modificarMovement(movement: mov)
                            alertMessage = "Movement updated"
                        } else {
                            // Add
                            movementsViewModel.guardarMovement(card: card!)
                            alertMessage = "Movement added"
                        }

                        isProcessing = false
                        showAlert = true

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            dismiss()
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text(movement != nil ? "Edit Movement" : "Add Movement")
                            .bold()
                        Spacer()
                    }
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .disabled(!isFormValid || isProcessing)
            }
            .padding()
            .blur(radius: isProcessing ? 3 : 0)

            // MARK: Spinner
            if isProcessing {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
        .onAppear {
            movementsViewModel.name = movement?.name ?? ""
            movementsViewModel.mount = movement?.price?.doubleValue ?? 0.0
            movementsViewModel.date = movement?.date ?? Date()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Success"),
                message: Text(
                    movement != nil ? "Movement updated!" : "Movement saved!"
                ),
                dismissButton: .default(Text("OK"))
            )
        }
        .presentationDetents([.height(350)])
    }
}
