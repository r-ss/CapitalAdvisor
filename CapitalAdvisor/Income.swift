//
//  Income.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 10/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class Income {    
    
    //var type:Type = .Cash
    
    var name: String = ""
    var value: Double = 0.0
    var currency:Currency = .RUB
    //var percent: Double = 0.0
    var note: String = ""
    
    let valueFormat:ValueFormat = ValueFormat()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var formattedValue:String { return valueFormat.format(self.value, currency: self.currency) }

    // MARK: Initialization
    init?(name: String,
        value: Double,
        currency:Currency,
        note: String = "")
    {
        self.name = name
        self.value = value
        self.currency = currency
        self.note = note

        //super.init()
        
        if value == 0.0 {
            return nil
        }
    }

    
    func getValueInDefaultCurrency() -> Double {
        return self.getValueInCurrency(defaultCurrency)
    }
    
    func getValueInCurrency(requiredCurrency:Currency) -> Double {
        let exchangeRates:ExchangeRates = appDelegate.exchangeRates
        //let defaultCurrency:Int = appDelegate.defaultCurrency
        
        switch self.currency {
        case .RUB:
            switch requiredCurrency {
            case .RUB:
                return self.value
            case .USD:
                return self.value / exchangeRates.USDRUR
            case .EUR:
                return self.value / exchangeRates.EURRUR
            }
        case .USD:
            switch requiredCurrency {
            case .RUB:
                return self.value * exchangeRates.USDRUR
            case .USD:
                return self.value
            case .EUR:
                return self.value / exchangeRates.EURUSD
            }
        case .EUR:
            switch requiredCurrency {
            case .RUB:
                return self.value * exchangeRates.EURRUR
            case .USD:
                return self.value * exchangeRates.EURUSD
            case .EUR:
                return self.value
            }
        }
    }

}