//
//  CodigoMorse.swift
//  CodigoMorse
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 13/11/25.
//

class CodigoMorse {
    var diccionario: [String: String] = [
        // Letras
        "a": ".-",
        "b": "-...",
        "c": "-.-.",
        "d": "-..",
        "e": ".",
        "f": "..-.",
        "g": "--.",
        "h": "....",
        "i": "..",
        "j": ".---",
        "k": "-.-",
        "l": ".-..",
        "m": "--",
        "n": "-.",
        "ñ":"--.--",
        "o": "---",
        "p": ".--.",
        "q": "--.-",
        "r": ".-.",
        "s": "...",
        "t": "-",
        "u": "..-",
        "v": "...-",
        "w": ".--",
        "x": "-..-",
        "y": "-.--",
        "z": "--..",

        // Números
        "1": ".----",
        "2": "..---",
        "3": "...--",
        "4": "....-",
        "5": ".....",
        "6": "-....",
        "7": "--...",
        "8": "---..",
        "9": "----.",
        "0": "-----",

        // Signos de puntuación
        ".": ".-.-.-",
        ",": "--..--",
        "?": "..--..",
        "'": ".----.",
        "!": "-.-.--",
        "/": "-..-.",
        "(": "-.--.",
        ")": "-.--.-",
        "&": ".-...",
        ":": "---...",
        ";": "-.-.-.",
        "=": "-...-",
        "+": ".-.-.",
        "-": "-....-",
        "_": "..--.-",
        "\"": ".-..-.",
        "$": "...-..-",
        "@": ".--.-.",

        // Espacio
        " ": "/",
    ]

    func textoAMorse(_ texto: String) -> String {
        var morse: String = ""
        let texto = texto.lowercased().split(separator: "")

        for letra in texto {
            let simbolo: String = diccionario[String(letra)] ?? ""
            morse += simbolo + " "
        }
        return morse
    }

    func morseATexto(_ texto: String) -> String {
        var traducido: String = ""
        let morse = texto.split(separator: " ")
        for codigo in morse {
            let letra: String = diccionario.keys.first(where: { diccionario[$0] == String(codigo) }) ?? " "
            traducido += letra
        }
        return traducido
    }
    
    
}
