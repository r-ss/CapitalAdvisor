//
//  Stock.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

//class Stock: NSObject, NSCoding {
class Stock {

    // MARK: Properties
    
//    enum Type {
//        case Cash, Bank, Deposit, Debit, Credit, Asset, Income
//    }

    //let typeNamesArray = ["Наличные", "Счёт", "Депозит", "Дебетовая карта", "Кредитная карта", "Актив", "Доход"]
    
    var type:Type = .Cash
    var type_name:String {
        switch type {
        case .Bank:
            return typeNamesArray[1]
        case .Deposit:
            return typeNamesArray[2]
        case .Debit:
            return typeNamesArray[3]
        case .Credit:
            return typeNamesArray[4]
        case .Asset:
            return typeNamesArray[5]
        case .Income:
            return typeNamesArray[6]
        default:
            return typeNamesArray[0]
        }
    }
    
    var name: String = ""
    var value: Double = 0.0
    var currency:Currency = .RUB
    var percent: Double = 0.0
    var color: UIColor = UIColor.whiteColor()

    let valueFormat:ValueFormat = ValueFormat()!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
/*
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("stocks")
    
    // MARK: Types
    struct PropertyKey {
        static let typeKey = "type"
        static let nameKey = "name"
        static let valueKey = "value"
        static let currencyKey = "currency"
        static let percentKey = "percent"
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(type, forKey: PropertyKey.typeKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(value, forKey: PropertyKey.valueKey)
        aCoder.encodeObject(currency, forKey: PropertyKey.currencyKey)
        aCoder.encodeObject(percent, forKey: PropertyKey.percentKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let type = aDecoder.decodeObjectForKey(PropertyKey.typeKey) as! Int
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let value = aDecoder.decodeObjectForKey(PropertyKey.valueKey) as! Double
        let currency = aDecoder.decodeObjectForKey(PropertyKey.currencyKey) as! Int
        let percent = aDecoder.decodeObjectForKey(PropertyKey.percentKey) as! Double
               
        
        self.init(  type: type,
                    name: name,
                    value: value,
                    currency: currency,
                    percent: percent
                    )
    }
*/
    // MARK: Initialization
    init?(  type: Type,
            name: String,
            value: Double,
            currency:Currency,
            percent: Double = 0.0,
            color:UIColor = UIColor.blackColor())
    {
        self.name = name
        self.type = type
        self.value = value
        self.currency = currency
        self.percent = percent
        self.color = color
        
        //super.init()
    
        if value == 0.0 {
            return nil
        }
    }
    
//    func getTypeValue() -> NSString {
//        return type_name
//        //return self.stocksTypesArray[self.type]
//    }
    
    func getValueInDefaultCurrency() -> Double {
        let exchangeRates:ExchangeRates = appDelegate.exchangeRates
        //let defaultCurrency:Int = appDelegate.defaultCurrency

        switch self.currency {
        case .USD:
            switch defaultCurrency {
            case .USD:
                return self.value
            case .EUR:
                return self.value / exchangeRates.EURUSD
            default:
                return self.value * exchangeRates.USDRUR
            }
        case .EUR:
            switch defaultCurrency {
            case .USD:
                return self.value * exchangeRates.EURUSD
            case .EUR:
                return self.value
            default:
                return self.value / exchangeRates.USDRUR
            }
        default:
            switch defaultCurrency {
            case .USD:
                return self.value / exchangeRates.USDRUR
            case .EUR:
                return self.value / exchangeRates.EURRUR
            default:
                return self.value
            }
        }
    
    
        
        
    }
    
    func getDisplayValue() -> NSString {
        return valueFormat.format(self.value, currency: self.currency)
    }
    
    func getDisplayPercent() -> NSString{
        return "\(self.percent * 100)%"
    }
    
    func getDisplayMonthlyReturn() -> NSString{
        
        let monthlyReturn:Double = (self.value * self.percent) / 12
        let monthlyReturnString:NSString = valueFormat.format(monthlyReturn, currency: self.currency)
        
        return "+ \(monthlyReturnString) в месяц"
        
    }
    
}