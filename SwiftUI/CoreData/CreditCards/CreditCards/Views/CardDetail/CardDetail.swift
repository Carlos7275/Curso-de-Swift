import CoreData
import SwiftUI
import Combine

struct CardDetail: View {
    var card: Cards
    var context: NSManagedObjectContext
    @State private var refreshID = UUID()
    @State private var showAddMovement = false
    @State private var editMovement: Movements?
    @State private var movementToDelete: Movements?
    @State private var showDeleteConfirm = false
    
    @FetchRequest var movimientos: FetchedResults<Movements>
    
    // Timer para refrescar crédito automáticamente cada minuto
    @State private var timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    init(card: Cards, context: NSManagedObjectContext) {
        self.card = card
        self.context = context
        
        // FetchRequest personalizado
        let request: NSFetchRequest<Movements> = Movements.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Movements.date, ascending: false)
        ]
        if let idCard = card.id {
            request.predicate = NSPredicate(format: "idCard == %@", idCard as CVarArg)
        }
        _movimientos = FetchRequest(fetchRequest: request)
    }
    
    @MainActor
    func refreshable() {
        refreshID = UUID()
    }
    
    // Filtramos solo los movimientos del mes actual
    private var monthlyMovements: [Movements] {
        let calendar = Calendar.current
        return movimientos.filter { mov in
            guard let date = mov.date else { return false }
            return calendar.isDate(date, equalTo: Date(), toGranularity: .month)
        }
    }
    
    // Total gastado en el mes
    private var totalSpentThisMonth: Double {
        monthlyMovements.reduce(0) { $0 + ($1.price?.doubleValue ?? 0) }
    }
    
    // Crédito disponible
    private var creditAvailable: Double {
        Double(card.credit) - totalSpentThisMonth
    }
    
    // Sobrepaso de límite
    private var overLimit: Bool {
        creditAvailable <= 0
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        cardSection
                        Divider().padding(.horizontal)
                        expensesSection
                        titleSection
                        movimientosSection
                        Spacer(minLength: 50)
                    }
                    .padding(.top)
                }
                .refreshable { refreshable() }
                .id(refreshID)
                .onReceive(timer) { _ in
                    refreshable()
                }
                
                floatingButton
            }
            .navigationTitle(card.name ?? "")
            .navigationBarTitleDisplayMode(.inline)
            
            // Sheets
            .sheet(item: $editMovement) { movement in
                AddMovement(
                    card: card,
                    movement: movement,
                    creditAvailable: creditAvailable,
                    context: context
                )
                .onDisappear { refreshable() }
            }
            .sheet(isPresented: $showAddMovement) {
                AddMovement(
                    card: card,
                    creditAvailable: creditAvailable,
                    context: context
                )
            }
            
            // Confirmación de eliminación
            .confirmationDialog("Delete movement?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let mov = movementToDelete {
                        withAnimation {
                            context.delete(mov)
                            try? context.save()
                            refreshable()
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

// MARK: - Secciones
extension CardDetail {
    
    // Tarjeta
    private var cardSection: some View {
        CreditCardPreview(
            data: PreviewCardData(
                name: card.name ?? "",
                number: card.number ?? "",
                credit: card.credit,
                type: CardType.from(card.type ?? "")
            )
        )
        .padding(.horizontal)
        .shadow(radius: 5)
    }
    
    // Título Movimientos
    private var titleSection: some View {
        Text("Movements")
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.horizontal)
    }
    
    // Gastos y crédito
    private var expensesSection: some View {
        let progress = min(totalSpentThisMonth / Double(card.credit), 1.0)
        
        return VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Expenses Total")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("$\(totalSpentThisMonth, specifier: "%.2f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(overLimit ? .red : .blue)
                    
                    Text("Credit Available: $\(creditAvailable, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(overLimit ? .red : .green)
                }
                
                Spacer()
                
                // Barra circular
                ZStack {
                    Circle()
                        .stroke(lineWidth: 6)
                        .opacity(0.2)
                        .foregroundColor(.gray)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(progress))
                        .stroke(overLimit ? Color.red : Color.blue, lineWidth: 6)
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut, value: progress)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption2)
                        .fontWeight(.bold)
                }
                .frame(width: 50, height: 50)
            }
            
            if overLimit {
                Text("⚠️ Credit limit exceeded! You cannot add more expenses.")
                    .foregroundColor(.red)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    // Movimientos
    @ViewBuilder
    private var movimientosSection: some View {
        VStack(spacing: 10) {
            if movimientos.isEmpty {
                emptyMovementsView
            } else {
                ForEach(movimientos) { mov in
                    MovementRow(mov: mov)
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                        .contextMenu {
                            Button { editMovement = mov } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            Button(role: .destructive) {
                                movementToDelete = mov
                                showDeleteConfirm = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.25), value: movimientos.count)
    }
    
    // Empty view
    private var emptyMovementsView: some View {
        VStack(spacing: 10) {
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.6))
            Text("No movements yet")
                .font(.headline)
                .foregroundColor(.gray.opacity(0.7))
            Text("Add your first expense to this card.")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, minHeight: 250)
        .frame(maxHeight: .infinity, alignment: .center)
        .padding(.top, 20)
    }
    
    // Floating Button
    private var floatingButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    showAddMovement = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(overLimit ? .gray : .accentColor)
                        .shadow(radius: 6)
                }
                .padding(20)
                .disabled(overLimit)
            }
        }
    }
}

// MARK: - Movimiento Row
struct MovementRow: View {
    let mov: Movements

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(mov.name ?? "")
                    .font(.headline)
                if let date = mov.date {
                    Text(date, formatter: dateFormatter)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Text("- \(currencyFormatter.string(for: mov.price ?? 0) ?? "$0.00")")
                .font(.headline)
                .foregroundColor(.red)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3)
    }
}

// MARK: - Formatters
private let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .none
    return df
}()

private let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter
}()
