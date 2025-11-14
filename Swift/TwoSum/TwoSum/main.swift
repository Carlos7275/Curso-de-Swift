//
//  main.swift
//  TwoSum
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 13/11/25.
//

import Foundation

class Solution {
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        let longitud = nums.count
        var numerosComplemento: [Int: Int] = [:]

        for indice in 0..<longitud {
            let numero = nums[indice]
            let complemento = target - numero

            if numerosComplemento.keys.contains(complemento) {
                let indiceInicial = numerosComplemento[complemento]!
                return [indiceInicial, indice]
            }

            numerosComplemento[numero] = indice

        }
        return []
    }
}

print(Solution.init().twoSum([2, 7, 11, 15], 9))
