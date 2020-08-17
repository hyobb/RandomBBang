//
//  Utils.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/08/14.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation

struct Helper {
    static let adUnitID = "ca-app-pub-9984637041740692/7562383028"
    static let currencyFormatter = NumberFormatter().then {
        $0.usesGroupingSeparator = true
        $0.numberStyle = .currencyAccounting
        $0.locale = Locale.current
        $0.maximumFractionDigits = 0
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
    
    static let ceilScale: Double = { 
        if Locale.current.identifier == "en_KR" {
            return 1000
        } else {
            return 10
        }
    }()
}
