//
//  ExchangeRates.swift
//  Capital
//
//  Created by Alex Antipov on 16/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

import Alamofire

class ExchangeRates {
    
    // MARK: Properties
    var USDRUR: Double = 65.0
    var EURRUR: Double = 75.0
    var EURUSD: Double = 1.12
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Initialization
    init?() {
        self.load()
        self.loadFromYahoo()
        
        //self.loadAAPL()
    }
    
    // MARK: Actions
    func loadFromYahoo() {
        Alamofire.request(.GET, "https://download.finance.yahoo.com/d/quotes.csv?e=.csv&f=c4l1&s=USDRUB=X,EURRUB=X,EURUSD=X")
            .responseString { _, _, result in
            //print("Success: \(result.isSuccess)")
            //print("Response String: \(result.value)")
            let resultString = (result.value)
            let responseArray = resultString!.componentsSeparatedByString("\n")
                    
            //print(responseArray.count)
                    
            if responseArray.count == 4 {
                    
                let USDRURString = responseArray[0].componentsSeparatedByString(",")[1]
                let EURRURString = responseArray[1].componentsSeparatedByString(",")[1]
                let EURUSDString = responseArray[2].componentsSeparatedByString(",")[1]
                self.USDRUR = Double(USDRURString)!
                self.EURRUR = Double(EURRURString)!
                self.EURUSD = Double(EURUSDString)!
                        
                self.save()
                print("Currencies loaded - USD: \(self.USDRUR), EUR: \(self.EURRUR), EURUSD: \(self.EURUSD)")
                NSNotificationCenter.defaultCenter().postNotificationName("Notification.exchangeRatesLoaded", object: nil)
            }
        }
    }
    
    func loadAAPL() {
        
        let symbol = "AAPL"
        let url = "https://download.finance.yahoo.com/d/quotes.csv?s=\(symbol)&f=sl1d1t1c1ohgv&e=.csv"
        
        Alamofire.request(.GET, url)
            .responseString { _, _, result in
                print("Success: \(result.isSuccess)")
                print("Response String: \(result.value)")
                let resultString = (result.value)
                //let responseArray = resultString!.componentsSeparatedByString("\n")
//                print("-----")
//                print(resultString)
//                print("-----")
        }
    }
    
    
    
    func save(){
        userDefaults.setDouble(self.USDRUR, forKey: "exchangeRatesUSDRUR")
        userDefaults.setDouble(self.EURRUR, forKey: "exchangeRatesEURRUR")
        userDefaults.setDouble(self.EURUSD, forKey: "exchangeRatesEURUSD")
        userDefaults.synchronize()
    }
    
    func load(){
        if let defaultsUSD = userDefaults.doubleForKey("exchangeRatesUSDRUR") as Double? {
            //print(defaultsUSD)
            if defaultsUSD != 0.0 {
                self.USDRUR = defaultsUSD
            }
        } else {
            print("NO USDRUR in defaults")
        }
        
        if let defaultsEUR = userDefaults.doubleForKey("exchangeRatesEURRUR") as Double? {
            //print(defaultsEUR)
            if defaultsEUR != 0.0 {
                self.EURRUR = defaultsEUR
            }
        } else {
            print("NO EURRUR in defaults")
        }
        
        if let defaultsEURUSD = userDefaults.doubleForKey("exchangeRatesEURUSD") as Double? {
            //print(defaultsEURUSD)
            if defaultsEURUSD != 0.0 {
                self.EURUSD = defaultsEURUSD
            }
        } else {
            print("NO EURUSD in defaults")
        }
    }
    
}

