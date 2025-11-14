//
//  CalculadoraBinaria.swift
//  SumaBinarios
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 14/11/25.
//

class CalculadoraBinaria {

    func sumaBinaria(_ num1: String, _ num2: String) -> String {
        var suma: String = ""

        var indiceNum1 = num1.count - 1
        var indiceNum2 = num2.count - 1
        var carry: String = "0"

        while indiceNum1 >= 0 || indiceNum2 >= 0 {
            let bit1 = indiceNum1 >= 0 ? num1[num1.index(num1.startIndex, offsetBy: indiceNum1)] : "0"
            let bit2 = indiceNum2 >= 0 ? num2[num2.index(num2.startIndex, offsetBy: indiceNum2)] : "0"
            
            var sumaBit = "0"
            
            if bit1 == "0" && bit2 == "0" {
                sumaBit = carry
                carry = "0"
            } else if (bit1 == "0" && bit2 == "1") || (bit1 == "1" && bit2 == "0") {
                sumaBit = carry == "1" ? "0" : "1"
                carry = carry == "1" ? "1" : "0"
            } else if bit1 == "1" && bit2 == "1" {
                sumaBit = carry == "1" ? "1" : "0"
                carry = "1"
            }
            
            suma = sumaBit + suma
            
            indiceNum1 -= 1
            indiceNum2 -= 1
        }

        if carry == "1" {
            suma = carry + suma
        }


        return suma
    }
}
