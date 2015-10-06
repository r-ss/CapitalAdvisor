//
//  Tips.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 06/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class Tips {
    
    var tips = [Tip]()
    
    //let appDelegate:AppDelegate!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    let valueFormat:ValueFormat = ValueFormat()
    
    var stocks:StocksContainer
    
    
    init(){
        
        self.stocks = appDelegate.container
    }
    
    
    func analyse() {
        
        self.tips.removeAll()

        searchPercentOfInvested()
        whatIfYouInvestAllCashFor12Percent()
        searchPercentOfRoubles()
    }
    
    
    
    
    func searchPercentOfInvested(){
        let total = stocks.totalStocksValueInCurrency(.RUB)
        let cash = stocks.totalStocksValueOfTypeInCurrency(.Cash, currency: .RUB)
        let percent = cash / total
        switch percent {
        case 0.25...0.49:
            let tip = Tip(text: "Вы держите больше четверти своих денег в виде наличных. Это неправильно, так как эти деньги не приносят никакого дохода.")
            self.tips.append(tip)
        case 0.5...0.99:
            let tip = Tip(text: "Вы держите больше половины своих денег в виде наличных. Это неправильно, так как эти деньги не приносят никакого дохода.")
            self.tips.append(tip)
        case 1:
            let tip = Tip(text: "Похоже, вы держите все свои деньги в виде наличных. Это неправильно, так как ваши деньги не приносят никакого дохода.")
            self.tips.append(tip)
        default:
            return
        }
    }
    
    func whatIfYouInvestAllCashFor12Percent(){
        //let total = stocks.totalStocksValueInCurrency(.RUB)
        let cash = stocks.totalStocksValueOfTypeInCurrency(.Cash, currency: .RUB)
        if cash > 100 {
            let devidend = cash * 0.12
            let tip = Tip(text: "Если положить все ваши наличные на рублевый депозит под 12% годовых, то через год вы получите доход <em> \(valueFormat.format(devidend, currency: .RUB)) </em>")
            self.tips.append(tip)
        }
    }
    
    func searchPercentOfRoubles(){
        
        //let totalRUB:Double = appDelegate.container.totalByCurrencies[.RUB]!
        let totalUSD:Double = appDelegate.container.totalByCurrencies[.USD]!
        let totalEUR:Double = appDelegate.container.totalByCurrencies[.EUR]!
        
        if totalUSD == 0 && totalEUR == 0 {
            let tip = Tip(text: "Похоже, вы держите все свои деньги в рублях. 😆")
            self.tips.append(tip)
        }
        
       
    }
    
    
    
    
}
