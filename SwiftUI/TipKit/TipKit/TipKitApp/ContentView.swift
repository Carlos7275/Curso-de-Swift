//
//  ContentView.swift
//  TipKit
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI
import TipKit

struct ContentView: View {
    @State private var show = false
    var body: some View {
        NavigationStack {
            VStack {
                Button {
                    show.toggle()
                } label: {
                    Image(systemName: "plus.circle").font(.title)
                        .foregroundColor(.black)
                }
                Text("Agregar nueva nota")
                    .font(.caption).foregroundStyle(.secondary)
                    .popoverTip(TipsView(), arrowEdge: .top) {
                        _ in
                        show.toggle()
                    }
            }
            .padding()
            .navigationTitle("Bienvenid@s")
            .popover(
                isPresented: $show,
                content: {
                    FormView()
                }
            )
        }.onAppear{
            try? Tips.resetDatastore()
        }
    }

}

#Preview {
    ContentView()
}
