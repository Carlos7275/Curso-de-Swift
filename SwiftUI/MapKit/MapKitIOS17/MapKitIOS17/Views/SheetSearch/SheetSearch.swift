//
//  SheetSearch.swift
//  MapKitIOS17
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI

struct SheetSearch: View {
    @Environment(MapViewModel.self) var mapViewModel
    @Binding var showSearch: Bool
    var body: some View {

        @Bindable var mapViewModel = mapViewModel

        NavigationStack {
            VStack {
                TextField("Buscar...", text: $mapViewModel.search)
                    .padding(12)
                    .background(.gray.opacity(0.1))
                    .presentationCornerRadius(6)
                    .foregroundStyle(.primary)

            }
            .onSubmit {
                Task {
                    await mapViewModel.searchPlace()
                    showSearch = false
                }
            }
            .padding(.all)
            .navigationTitle("Buscar Lugar")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
