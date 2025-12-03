//
//  WikiView.swift
//  WikiSynthesizer
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI

struct WikiView: View {

    var search: String
    @State private var voiceViewModel = VoiceViewModel()
    @Environment(VoiceViewModel.self) var voice
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            ScrollView {
                Text(voiceViewModel.wikiResult)
            }
            HStack(alignment: .center, spacing: 30) {
                ButtonIcon(icon: "speaker.circle.fill") {
                    voiceViewModel.speak(lang: voice.lang)
                }

                ButtonIcon(icon: "stop.circle.fill") {
                    voiceViewModel.stopSpeak()
                }

                ButtonIcon(icon: "arrowshape.backward.circle.fill") {
                    voiceViewModel.stopSpeak()
                    dismiss()
                }
            }
        }.padding(.all)
            .navigationTitle(search)
            .onAppear {
                voiceViewModel.fetchWiki(search: search, lang: voice.lang)
            }
    }
}
