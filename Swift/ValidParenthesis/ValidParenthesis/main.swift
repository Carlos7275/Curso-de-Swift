//
//  main.swift
//  ValidParenthesis
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 13/11/25.
//

import Foundation

print(Solution.init().isValid("{()}}"))

class Solution {
    func isValid(_ s: String) -> Bool {
        //Diccionario con los simbolos de apertura y cierre
        var stack: [Character] = []
        let dic = ["(": ")", "{": "}", "[": "]"]

        for caracter in s {
            if dic.keys.contains(String(caracter)) {
                stack.append(caracter)
            } else {
                
                
                guard let ultimo = stack.popLast() else {return false}
                if dic[String(ultimo)] != String(caracter) {
                    return false
                }

            }
        }
        return stack.count == 0
    }
}

