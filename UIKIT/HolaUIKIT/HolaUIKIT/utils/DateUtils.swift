//
//  DateUtils.swift
//  HolaUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//

import Foundation

class DateUtils {
    static func calculateAge(birthDay:DateComponents)->Int{
        let calendar = Calendar.current;
        
        return  calendar.dateComponents([.year], from: calendar.date(from:birthDay)!, to: Date()).year!
    }
}
