import CoreData
import SwiftUI

struct HomeView: View {
    var context: NSManagedObjectContext

    @ObservedObject var cardViewModel: CardsViewModel

    @State private var showDeleteConfirm = false
    @State private var editCard: Cards?
    @State private var cardToDelete: Cards?

    @FetchRequest(entity: Cards.entity(), sortDescriptors: [])
    var cards: FetchedResults<Cards>

    init(context: NSManagedObjectContext) {
        self.context = context
        _cardViewModel = ObservedObject(
            wrappedValue: CardsViewModel(context: context)
        )
    }

    @MainActor
    func refreshCards() async {
        cards.nsPredicate = nil  // Refresca el FetchRequest
    }

    @State private var show = false

    var body: some View {
        NavigationStack {
            ZStack {

                // MARK: - EMPTY STATE
                if cards.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "creditcard")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.6))

                        Text("No credit cards")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.gray.opacity(0.8))

                        Text("Add your first card using the button below.")
                            .font(.subheadline)
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    .padding(.top, 60)

                } else {

                    // MARK: - LISTA DE TARJETAS
                    ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(cards) { card in
                                NavigationLink {
                                    CardDetail(card: card, context: context)
                                } label: {
                                    CreditCardPreview(
                                        data: PreviewCardData(
                                            name: card.name ?? "",
                                            number: card.number ?? "",
                                            credit: card.credit,
                                            type: CardType.from(
                                                card.type ?? ""
                                            ),

                                        ),
                                        isDetail: true,
                                        isClipboardEnabled: false,
                                    )
                                    .padding(.all)
                                    .shadow(radius: 5)
                                }

                                // MARK: - CONTEXT MENU
                                .contextMenu {
                                    Button {
                                        editCard = card
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }

                                    Button(role: .destructive) {
                                        cardToDelete = card
                                        showDeleteConfirm = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }

                                .transition(
                                    .asymmetric(
                                        insertion: .opacity.animation(
                                            .easeInOut(duration: 0.25)
                                        ),
                                        removal: .move(edge: .leading).combined(
                                            with: .opacity
                                        )
                                    )
                                )
                            }
                        }
                        .padding(.top, 20)
                        .animation(
                            .easeInOut(duration: 0.28),
                            value: cards.count
                        )
                    }
                    .refreshable {
                        await refreshCards()
                    }
                }

                // MARK: - BOTÓN FLOTANTE
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            show.toggle()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.accentColor)
                                .shadow(radius: 5)
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("Credit Cards")

            // MARK: - ADD CARD SHEET
            .sheet(isPresented: $show) {
                AddCardView(context: context)
            }

            // MARK: - EDIT CARD SHEET
            .sheet(item: $editCard) { card in
                AddCardView(card: card, context: context)
            }

            // MARK: - DELETE CONFIRMATION
            .confirmationDialog(
                "Delete card?",
                isPresented: $showDeleteConfirm,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) {
                    if let card = cardToDelete {
                        withAnimation {
                            cardViewModel.eliminarCard(card: card)
                        }
                    }
                }

                Button("Cancel", role: .cancel) {}
            }
        }
    }
}
