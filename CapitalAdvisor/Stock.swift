//
//  Stock.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class Stock: NSObject, NSCoding {

    // MARK: Properties
    let typeNamesArray = ["Наличные", "Счёт", "Депозит", "Дебетовая карта", "Кредитная карта", "Актив", "Доход"]
    
    var type:Int = 0
    var type_name:String {
        return typeNamesArray[type]
    }
    
    var name: String = ""
    var value: Double = 0.0
    var currency: Int = 0 // 0=RUB, 1=USD, 2=EUR
    var percent: Double = 0.0
    var color: UIColor = UIColor.blackColor()

    let valueFormat:ValueFormat = ValueFormat()!
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    

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

    // MARK: Initialization
    init?(  type: Int,
            name: String,
            value: Double,
            currency: Int,
            percent: Double = 0.0,
            color:UIColor = UIColor.blackColor())
    {
        self.name = name
        self.type = type
        self.value = value
        self.currency = currency
        self.percent = percent
        self.color = color
        
        super.init()
    
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
        let defaultCurrency:Int = appDelegate.defaultCurrency
        
        
        switch self.currency {
        case 1:
            switch defaultCurrency {
            case 1:
                return self.value
            case 2:
                return self.value / exchangeRates.EURUSD
            default:
                return self.value * exchangeRates.USDRUR
            }
        case 2:
            switch defaultCurrency {
            case 2:
                return self.value * exchangeRates.EURUSD
            case 1:
                return self.value
            default:
                return self.value / exchangeRates.USDRUR
            }
        default:
            switch defaultCurrency {
            case 1:
                return self.value / exchangeRates.USDRUR
            case 2:
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