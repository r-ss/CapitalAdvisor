//
//  ValueFormat.swift
//  Capital
//
//  Created by Alex Antipov on 16/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

extension String {
    var convertedToDouble: Double {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = ","
        converter.usesSignificantDigits = false
        
        converter.minimumFractionDigits = 0
        converter.maximumFractionDigits = 2
        converter.roundingMode = NSNumberFormatterRoundingMode.RoundFloor
        converter.locale = NSLocale(localeIdentifier: "ru_RU")
        if let result = converter.numberFromString(self) {
            return result.doubleValue
        } else {
            converter.decimalSeparator = "."
            if let result = converter.numberFromString(self) {
                return result.doubleValue            }
        }
        return 0
    }
}

extension Double {
    var convertedToString: String {
        let converter = NSNumberFormatter()
        converter.decimalSeparator = "."
        converter.usesSignificantDigits = true
        converter.minimumFractionDigits = 0
        converter.maximumFractionDigits = 10
        converter.maximumSignificantDigits = 10
        if let result = converter.stringFromNumber(self) {
            return result
        }
        return ""
    }
}

class ValueFormat {
    // MARK: Actions
    func format(number: Double, currency: Currency, adaptive: Bool = false) -> String {
        // format value based on currency
        let formatter = NSNumberFormatter()
        formatter.groupingSize = 3
        formatter.groupingSeparator = " "
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
       
        formatter.usesSignificantDigits = false
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        formatter.roundingMode = NSNumberFormatterRoundingMode.RoundFloor
        
        //formatter.minimumSignificantDigits = 0;
        //formatter.maximumSignificantDigits = 2;

        switch currency {
        case .USD:
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            //formatter.positivePrefix = "$"
            //formatter.maximumFractionDigits = 3
        case .EUR:
            formatter.locale = NSLocale(localeIdentifier: "de_DE")
            //formatter.positivePrefix = "€"
            //formatter.maximumFractionDigits = 3
        default:
            formatter.locale = NSLocale(localeIdentifier: "ru_RU")
            //formatter.positiveSuffix = "р."
            //formatter.maximumFractionDigits = 3
        }
        
        if adaptive {
            formatter.maximumFractionDigits = 0
        }
        
        return formatter.stringFromNumber(number)!
    }
}