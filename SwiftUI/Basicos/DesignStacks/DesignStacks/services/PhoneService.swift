//
//  PhoneService.swift
//  DesignStacks
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//

import SwiftUI

struct PhoneService{

    static func sendMessage(numero:String,mensaje:String){
        let sms = "sms:\(numero)&body=\(mensaje)"
        UIApplication.shared.open(URL(string: sms)!)
    }

    static  func sendCall(numero:String){
       guard let number  = URL(string:"tel://\(numero)") else{ return}
        
        UIApplication.shared.open(number)
            
    }
}
