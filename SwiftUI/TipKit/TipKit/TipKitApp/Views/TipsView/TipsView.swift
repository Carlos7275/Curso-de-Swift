//
//  Tips.swift
//  TipKit
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 02/12/25.
//

import SwiftUI
import TipKit

struct TipsView: Tip {
    var title: Text {
        Text("Crear notas")
    }
    var message: Text? {
        Text("Comienza a escribir notas")
    }

    var image: Image? {
        Image(systemName: "note")
    }

    var actions: [Action] {
        [Tip.Action(id: "vermas", title: "Ver mas")]

    }
}

struct TipsView2: Tip {

    static var entrada: Event = Event(id: "form")
    var title: Text {
        Text("Formulario de notas")
    }
    var message: Text? {
        Text("Desde aqui comienza a crear tus notas")
    }

    var image: Image? {
        Image(systemName: "pencil.and.scribble")
    }

    var rules: [Rule] {
        return [
            #Rule(Self.entrada) {
                $0.donations.count >= 3
            }
        ]
    }

}

struct TipsView3: Tip {

    @Parameter()
    static var showTip: Bool = false
    var title: Text {
        Text("Genial!!!")
    }
    var message: Text? {
        Text("Bien hecho has guardado tu primer nota sigue asi")
    }

    var image: Image? {
        Image(systemName: "pencil.and.scribble")
    }

    var rules: [Rule] {
        return [
            #Rule(Self.$showTip) {
                $0 == true
            }
        ]
    }

}
