//
//  main.swift
//  CodigoMorse
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 13/11/25.
//

import Foundation

var codigoMorse = CodigoMorse()


var opc: Int = -1
while opc != 3 {
    print("\u{001B}[2J") // Limpia la pantalla en sistemas que soportan ANSI
    print("Traductor de Lenguaje natural a morse")
    print("=======================================")
    print("1.- Texto a Codigo morse.\n2.- Codigo morse a texto.\n3.-Salir de la app.")
    print("=======================================")
    
    // Obtener la opción del usuario
    if let input = readLine(), let option = Int(input) {
        opc = option
    } else {
        opc = 0 // Si la entrada no es válida, consideramos la opción 0
    }
    
    switch opc {
    case 1:
        print("Texto a codigo morse")
        print("Introduce el texto a convertir a morse:")
        if let texto = readLine() {
            print(codigoMorse.textoAMorse(texto))
        } else {
            print("Entrada no válida.")
        }
        
    case 2:
        print("Codigo morse a texto")
        print("Introduce la clave morse a convertir a lenguaje natural:")
        if let codigo = readLine() {
            let texto = codigoMorse.morseATexto(codigo)
            print(texto)
        } else {
            print("Entrada no válida.")
        }
        
    case 3:
        print("¡Adios!")
        
    default:
        print("¡Opción inválida!")
    }
    
    // Pausar el programa hasta que el usuario presione "Enter"
    if opc != 3 {
        print("\nPresiona Enter para continuar...")
        _ = readLine() // Esperar por el input del usuario antes de continuar
    }
}