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

extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 2)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
        layer.masksToBounds = false
    }
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

extension UIView {
    func addShadow(opacity: Float = 0.7) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    func addCornerRadius(corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: CGFloat = 15) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
        clipsToBounds = true
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.addCornerRadius(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], cornerRadius: 15)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
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
            
            let minValue = min(double, Double(1_000_000_000))
            
            guard number != 0 as NSNumber else {
                return Observable.just("")
            }
            
            return Observable.just(Helper.getCurrencyString(from: Int(minValue)))
        }
    }
}
