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
        
        let long = "Деньги должны работать, так же как и вы. Это приложение поможет вам задуматься и начать правильно распоряжаться своими деньгами. Мы не сотрудничаем ни с одим банком или организацией и не рекламируем их услуги."
        
        switch percent {
        case 0.25...0.49:
            let tip = Tip(intro: "Вы держите больше четверти своих денег в виде наличных. Это неправильно, так как эти деньги не приносят никакого дохода.", text: long)
            self.tips.append(tip)
        case 0.5...0.99:
            let tip = Tip(intro: "Вы держите больше половины своих денег в виде наличных. Это неправильно, так как эти деньги не приносят никакого дохода.", text: long)
            self.tips.append(tip)
        case 1:
            let tip = Tip(intro: "Похоже, вы держите все свои деньги в виде наличных. Это неправильно, так как ваши деньги не приносят никакого дохода.", text: long)
            self.tips.append(tip)
        default:
            return
        }
    }
    
    func whatIfYouInvestAllCashFor12Percent(){
        //let total = stocks.totalStocksValueInCurrency(.RUB)
        let cash = stocks.totalStocksValueOfTypeInCurrency(.Cash, currency: .RUB)
        
        let long = "Однако, депозиты неудобны тем, что вы не можете пользоваться своими деньгами до окончания депозита без потери процентов. Поэтому мы рекомендуем вам воспользоваться накопительными счетами и картами с выплатой процентов на остаток — по таким картам вы будете получать 7-8% на остаток и сможете свободно пользоваться своими деньгами. Мы рекомендуем держать на таких картах сумму, достаточную на один-два месяца, в зависимости от уровня ваших расходов, а остальные деньги положить на обычный депозит или распределить в более выгодные инструменты, не забывая о возможных рисках."
        
        if cash > 100 {
            let devidend = cash * 0.12
            let tip = Tip(intro: "Если положить все ваши наличные на рублевый депозит под 12% годовых, то через год вы получите доход <em> \(valueFormat.format(devidend, currency: .RUB)) </em>", teaser:"Узнать больше", text: long)
            self.tips.append(tip)
        }
    }
    
    func searchPercentOfRoubles(){
        
        //let totalRUB:Double = appDelegate.container.totalByCurrencies[.RUB]!
        let totalUSD:Double = appDelegate.container.totalByCurrencies[.USD]!
        let totalEUR:Double = appDelegate.container.totalByCurrencies[.EUR]!
        
        let long = "Рубль – это крайне нестабильная валюта, которая напрямую зависит от цены на нефть. В современной истории России были случаи, когда рубль обесценивался более чем в два раза, в частности в конце 2014 года. Это делает довольно рискованным инвестиции в рублевые активы. Зачастую, депозиты в валюте оказываются гораздо надежнее рублевых несмотря на небольшую процентную ставку по сравнению с вкладами в рублях. А в случае обвала рубля, валютные депозиты приносят сверхдоход в рублевом эквиваленте. Мы рекомендуем вам держать не менее 30% в валюте - Долларах или Евро. А разделив свои активы поровну между тремя валютами, вы защитите себя от их колебаний, так как падение одной валюты будет компенсироваться ростом других. Конечно вы сами должны решить, как распределить свои средства. И, безусловно, ваши валютные активы, как и рублевые, должны работать. Проще говоря, должны быть куда-то инвестированы: депозиты, акции, фонды и так далее."
        
        if totalUSD == 0 && totalEUR == 0 {
            let tip = Tip(intro: "Похоже, вы храните все свои деньги в рублях 😆", teaser: "Почему это неправильно?", text: long)
            self.tips.append(tip)
        }
        
       
    }
    
    
    
    
}
