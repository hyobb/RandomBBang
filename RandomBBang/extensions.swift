//
//  extensions.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/08/08.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import UIColor_Hex_Swift
import RxSwift

extension UIColor {
    static let primaryGray = UIColor("#353537")
    static let darkGray = UIColor("#1f2021")
    static let lightGray = UIColor("#969595")
    
    static let primaryBlue = UIColor("#2078dd")
}

extension ObservableType where Element == String {
    func valueToCurrencyFormatted() -> Observable<Element> {
        return asObservable().flatMap { valueString -> Observable<Element> in
            var amountWithPrefix = valueString
            var number: NSNumber!
            
            let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
            amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, valueString.count), withTemplate: "")
            
            let double = (amountWithPrefix as NSString).doubleValue
            number = NSNumber(value: (double / 100))
            
            guard number != 0 as NSNumber else {
                return Observable.just("")
            }
            return Observable.just(Helper.getCurrencyString(from: Int(double)))
        }
  }
}
