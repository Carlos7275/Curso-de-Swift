//
//  VoiceViewModel.swift
//  WikiSynthesizer
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import Foundation
import Observation
import Speech
import WikipediaKit

@Observable
class VoiceViewModel {
    var lang = "es"
    var wikiResult = ""

    let synthesizer = AVSpeechSynthesizer()
    var speaking: Bool = false
    var fragments: [Substring] = []

    func fetchWiki(search: String, lang: String) {
        let _ = Wikipedia.shared.requestOptimizedSearchResults(
            language: WikipediaLanguage(lang),
            term: search
        ) { searchResult, error in
            guard error == nil else { return }
            guard let searchResult = searchResult else { return }

            for article in searchResult.items {
                self.wikiResult.append(article.displayText)
            }
        }
    }

    func speak(lang: String) {
        if !speaking {
            speaking = true
            fragments = wikiResult.split(separator: ",")
            speakFragment(fragment: fragments, lang: lang)
        }
    }

    func speakFragment(fragment: [Substring], lang: String) {

        var voiceLang = ""
        switch lang {
        case "en":
            voiceLang = "com.apple.voice.compact.en-US.Samantha"
        case "fr":
            voiceLang = "com.apple.voice.compact.fr-FR.Isabelle"
        case "it":
            voiceLang = "com.apple.voice.compact.it-IT.Francesca"
        default:
            voiceLang = "com.apple.voice.compact.en-MX.Paulina"
        }
        let voice = AVSpeechSynthesisVoice(identifier: voiceLang)

        if let firstFragment = fragment.first, !firstFragment.isEmpty {
            let utterance = AVSpeechUtterance(string: String(firstFragment))
            utterance.rate = 0.5
            utterance.voice = voice
            synthesizer.speak(utterance)
        }

        if fragment.count > 1 {
            let fragmentArray = Array(fragment.dropFirst())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.speakFragment(fragment: fragmentArray, lang: lang)
            }

        } else {
            speaking = false
        }

    }

    func stopSpeak() {
        fragments.removeAll()
        synthesizer.pauseSpeaking(at: .immediate)
        speaking = false
    }

}
