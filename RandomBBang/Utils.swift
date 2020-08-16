//
//  Utils.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/08/14.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation

struct Helper {
    static let currencyFormatter = NumberFormatter().then {
        $0.usesGroupingSeparator = true
        $0.numberStyle = .currency
        $0.locale = Locale.current
    }
    
    static func getCurrencyString(from number: Int) -> String {
        let nsNum = NSNumber(value: number)
        if let currencyString = currencyFormatter.string(from: nsNum) {
            return currencyString
        } else {
            return "\(number)"
        }
    }
    
    static func getIntValue(from currencyString: String) -> Int? {
        if let num = currencyFormatter.number(from: currencyString) {
            return num.intValue
        }
        return nil
    }
}
