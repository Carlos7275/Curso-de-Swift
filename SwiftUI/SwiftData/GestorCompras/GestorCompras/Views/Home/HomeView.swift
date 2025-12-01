//
//  HomeView.swift
//  GestorCompras
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 28/11/25.
//

import SwiftData
import SwiftUI

struct HomeView: View {

    @Environment(\.modelContext) var context: ModelContext
    @State private var show = false
    @StateObject private var listViewModel: ComprasViewModel
    @Query(
        filter: #Predicate<Compras> { $0.completado == false },
        sort: \Compras.titulo,
        order: .forward
    ) private var items: [Compras]

    @Query(
        filter: #Predicate<Compras> { $0.completado == true },
        sort: \Compras.titulo,
        order: .forward
    ) private var itemsCompleted: [Compras]

    init(context: ModelContext) {
        _listViewModel = StateObject(
            wrappedValue: ComprasViewModel(context: context)
        )
    }
    var body: some View {
        NavigationStack {
            List {
                Section("Activas") {
                    ForEach(items) {
                        item in
                        NavigationLink(value: item) {
                            CardView(item: item).swipeActions {
                                Button(role: .destructive) {
                                    withAnimation {
                                        self.listViewModel.eliminarDato(
                                            item: item
                                        )
                                    }

                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                        }
                    }
                }
                Section("Completadas") {
                    ForEach(itemsCompleted) {
                        item in
                        CardCompleteView(item: item).swipeActions {
                            Button(role: .destructive) {
                                withAnimation {
                                    self.listViewModel.eliminarDato(
                                        item: item
                                    )
                                }

                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }

                }
            }
            .navigationTitle("Gestor de compras")

            .toolbar {
                ToolbarItem {
                    Button {
                        show.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }

            .sheet(
                isPresented: $show,
                content: {
                    NavigationStack {
                        AddView(context: context)
                    }.presentationDetents([.medium])
                }
            )
            .navigationDestination(for: Compras.self) {
                ComprasView(itemList: $0, context: context)
            }
        }.refreshable {
            try! self.context.save()
        }
    }
}
