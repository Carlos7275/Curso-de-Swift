//
//  ContentView.swift
//  WikiSynthesizer
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI

struct ContentView: View {
    @State private var search = ""
    @Environment(VoiceViewModel.self) var voiceViewModel
    var body: some View {
        NavigationStack {
            VStack {
                Text("Wiki").font(.system(size: 70))
                Text("Synthetizer").font(.largeTitle)

                TextField("Buscar", text: $search)
                    .textFieldStyle(.roundedBorder)

                Spacer().frame(height: 20)
                Picker("Idioma", selection: Bindable(voiceViewModel).lang) {
                    Text("Español").tag("es")
                    Text("Ingles").tag("en")
                    Text("Italiano").tag("it")
                    Text("Frances").tag("fr")
                }.pickerStyle(.segmented)

                Spacer().frame(height: 20)

                NavigationLink(value: search) {
                    Text("Buscar")
                }.buttonStyle(.borderedProminent)
                    .tint(.blue)
                Spacer()
            }.padding(.all)
                .navigationDestination(for: String.self) { value in
                    WikiView(search: value)
                }
        }
    }
}
