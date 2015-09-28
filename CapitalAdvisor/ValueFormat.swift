//
//  ValueFormat.swift
//  Capital
//
//  Created by Alex Antipov on 16/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class ValueFormat {
    
    // MARK: Properties
    
    // MARK: Initialization
    init?() {
        
    }
    
    // MARK: Actions
    func format(number: Double, currency: Currency, adaptive: Bool = false) -> String {
        // format value based on currency
        let formatter = NSNumberFormatter()
        formatter.groupingSize = 3
        formatter.groupingSeparator = " "
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        //doubleValF.maximumSignificantDigits = 30;
        //formatter.minimumFractionDigits = 0
        
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