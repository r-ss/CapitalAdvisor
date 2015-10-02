//
//  Stock.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class Stock {

    
    var type:Type = .Cash
    
    var name: String = ""
    var value: Double = 0.0
    var currency:Currency = .RUB
    var percent: Double = 0.0
    var note: String = ""
    var color: UIColor = UIColor.whiteColor()

    let valueFormat:ValueFormat = ValueFormat()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var devidendYear:Double { return self.value * self.percent }
    var devidendMonth:Double { return devidendYear / 12 }
    var devidendDay:Double { return devidendYear / 365 }
    var formattedDevidendYear:String { return "+ \(valueFormat.format(self.devidendYear, currency: self.currency)) в год" }
    var formattedDevidendMonth:String { return "+ \(valueFormat.format(self.devidendMonth, currency: self.currency)) в месяц" }
    var formattedDevidendDay:String { return "+ \(valueFormat.format(self.devidendDay, currency: self.currency)) в день" }
    
    var formattedValue:String { return valueFormat.format(self.value, currency: self.currency) }
    var formattedPercent:String { return "\(self.percent * 100)%" }
    
    // MARK: Initialization
    init?(  type: Type,
            name: String,
            value: Double,
            currency:Currency,
            percent: Double = 0.0,
            note: String = "",
            color:UIColor = UIColor.whiteColor())
    {
        self.name = name
        self.type = type
        self.value = value
        self.currency = currency
        self.percent = percent
        self.note = note
        self.color = color
        
        //super.init()
    
        if value == 0.0 {
            return nil
        }
    }
    
    func getPercentInTotalStocksValue() -> Double {
        let totalStocksValue = appDelegate.container.totalStocksValueInCurrency(defaultCurrency)
        let valueOfThisStock = getValueInCurrency(defaultCurrency)
        return valueOfThisStock / totalStocksValue
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