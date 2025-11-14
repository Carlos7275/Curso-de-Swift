//
//  main.swift
//  CodigoMorse
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 13/11/25.
//

import Foundation

var codigoMorse = CodigoMorse()
let codigo = codigoMorse.textoAMorse("Como diria el renancio ff ")
print(codigo)
print(codigoMorse.morseATexto(codigo))
