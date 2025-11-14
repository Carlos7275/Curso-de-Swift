//
//  main.swift
//  SumaBinarios
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 14/11/25.
//

import Foundation

let calcBin = CalculadoraBinaria()

print("Calculadora Binaria")
print("===================================")
print("Ingrese un numero en binario:")
let numBin1 = readLine()!
print("Ingrese otro numero en binario:")
let numBin2 = readLine()!
print(calcBin.sumaBinaria(numBin1, numBin2))
print("===================================")
