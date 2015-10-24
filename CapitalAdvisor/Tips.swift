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

        searchPercentOfInvested()               // 1
        whatIfYouInvestAllCashFor12Percent()    // 2
        whatIfInvestFor10Years()                // 3
        incomeToCapitalRatio()                  // 4
        searchPercentOfRoubles()                // 5
        strahovkaDeposit()                      // 6
        fillStocksAndSeeMore()                  // 7
        bewareOfForex()                         // 8
    }
    
    
    
    
    func searchPercentOfInvested(){
        let total = stocks.totalStocksValueInCurrency(.RUB)
        let cash = stocks.totalStocksValueOfTypeInCurrency(.Cash, currency: .RUB)
        let percent = cash / total
        
        let long = "Деньги должны работать, так же как и вы. Это приложение поможет вам задуматься и начать разумно распоряжаться своими деньгами. Мы не сотрудничаем ни с одним банком или организацией и не рекламируем их услуги."
        
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
        
        let long = "Однако, депозиты неудобны тем, что вы не можете пользоваться своими деньгами до окончания депозита без потери процентов. Поэтому мы рекомендуем вам воспользоваться накопительными счетами и картами с выплатой процентов на остаток — по таким картам вы будете получать 7-8% на остаток и сможете свободно пользоваться своими деньгами. Есть смысл держать на таких картах сумму, достаточную на один-два месяца, в зависимости от уровня ваших расходов, а остальные деньги положить на обычный депозит или распределить в более выгодные инструменты, не забывая о возможных рисках."
        
        if cash > 100 {
            let devidend = cash * 0.12
            let tip = Tip(intro: "Если положить все ваши наличные на рублевый депозит под 12% годовых, то через год вы получите доход <em>_\(valueFormat.format(devidend, currency: .RUB))_</em>", teaser:"Узнать больше", text: long)
            self.tips.append(tip)
        }
    }
    
    
    func whatIfInvestFor10Years(){
        
        let long = "Время — один из самых важных факторов инвестирования. Чем раньше вы начнете накапливать сбережения, тем более солидная сумма накопится у вас через 10-20 лет благодаря регулярным пополнениям и «магии» сложных процентов."
        
        let currentTotal = stocks.totalStocksValueInCurrency(.RUB)
        
        var total = currentTotal
        var totalDevidents:Double = 0
        
        let percent:Double = 0.10
        
        let totalIncome = stocks.totalIncomesValueInCurrency(.RUB)
        
        var monthly:Double = 10000
        if totalIncome > 1000 {
            monthly = totalIncome * 0.15
        }
        
        for _ in 0...9 {
            total += monthly * 12
            let devidends = total * percent
            totalDevidents += devidends
            total += devidends
            //print("index: \(index), devidends: \(devidends) total:\(total)")
        }
        
        let tip1 = Tip(intro: "Если вы начнете инвестировать свой капитал <em>_\(valueFormat.format(currentTotal, currency: .RUB))_</em> под 10% годовых и ежемесячно будете добавлять к сумме 15% от ваших доходов <em>_(\(valueFormat.format(monthly, currency: .RUB)))_</em>, то через десять лет ваш капитал составит <em>_\(valueFormat.format(total, currency: .RUB))_</em> из которых <em>_\(valueFormat.format(stocks.totalStocksValueInCurrency(.RUB) + (monthly * 12 * 10), currency: .RUB))_</em> — вложенные вами деньги и <em>_\(valueFormat.format(totalDevidents, currency: .RUB))_</em> — девиденды", teaser:"Узнать больше", text: long)
        
        let tip2 = Tip(intro: "Если вы начнете инвестировать свой капитал <em>_\(valueFormat.format(currentTotal, currency: .RUB))_</em> под 10% годовых и ежемесячно будете добавлять к сумме <em>_\(valueFormat.format(monthly, currency: .RUB))_</em>, то через десять лет ваш капитал составит <em>_\(valueFormat.format(total, currency: .RUB))_</em> из которых <em>_\(valueFormat.format(stocks.totalStocksValueInCurrency(.RUB) + (monthly * 12 * 10), currency: .RUB))_</em> — вложенные вами деньги и <em>_\(valueFormat.format(totalDevidents, currency: .RUB))_</em> — девиденды", teaser:"Узнать больше", text: long)
        
        if totalIncome > 1000 {
            self.tips.append(tip1)
        } else {
            self.tips.append(tip2)
        }
        
        
    }
    
    func incomeToCapitalRatio(){
        let totalCapital = stocks.totalStocksValueInCurrency(.RUB)
        let totalIncome = stocks.totalIncomesValueInCurrency(.RUB)
        let x3:Double = totalIncome * 3
        if x3 > totalCapital {
            let long = "Очень важно иметь финансовую «подушку безопасности» — некоторую сумму средств, которой вам будет достаточно хотя бы на 2-3 месяца в случае исчезновения источников доходов. Это позволит вам в случае непредвиденных обстоятельств уверенно их преодолеть."
            let tip = Tip(intro: "Сумма ваших накоплений меньше трехкратной суммы вашего ежемесяжного дохода. Рекомендуется иметь накопления, которых будет достаточно как минимум на три месяца жизни при вашем обычном уровне расходов.", teaser: "Подробнее", text: long)
            self.tips.append(tip)
        }
    }
    
    
    func searchPercentOfRoubles(){
        
        //let totalRUB:Double = appDelegate.container.totalByCurrencies[.RUB]!
        let totalUSD:Double = appDelegate.container.totalByCurrencies[.USD]!
        let totalEUR:Double = appDelegate.container.totalByCurrencies[.EUR]!
        
        let long = "Рубль — валюта, которая находится в прямой зависимости от мировых цен на нефть, которые, в свою очередь, непредсказуемы. В современной истории России были случаи, когда рубль за короткий срок обесценивался в полтора и даже два раза. Это делает довольно рискованным инвестиции в рублевые активы. В периоды нестабильности рубля, депозиты в валюте оказываются гораздо надежнее рублевых несмотря на небольшую процентную ставку по сравнению с вкладами в рублях. Мы рекомендуем вам держать не менее 30% в валюте — долларах или евро. А разделив свои активы поровну между тремя валютами, вы защитите себя от колебаний курсов, так как падение одной валюты будет компенсироваться ростом других. Разумеется вы сами должны решить, как распределить свои средства. И конечно ваши валютные активы, как и рублевые, должны работать, то есть быть инвестированы: в депозиты, акции, фонды и так далее."
        
        if totalUSD == 0 && totalEUR == 0 {
            let tip = Tip(intro: "Похоже, вы храните все свои деньги в рублях 😆", teaser: "Почему это неправильно?", text: long)
            self.tips.append(tip)
        }
        
       
    }
    
    func strahovkaDeposit(){
        
        for stock in appDelegate.container.stocks {
            
            switch stock.type {
            case .Deposit:
                if stock.getValueInCurrency(.RUB) > 1400000 {
                    let long = "В России действует система страхования вкладов. Если банк, в котором у размещен ваш депозит участвует в этой программе, то все ваши вклады до 1,4 миллиона рублей в этом банеке застрахованы и даже в случае банктротства банка государство вернет вам эту сумму. Однако если депозит превышает 1,4 млн. рублей, то часть, превышающая страховую сумму не будет возвращена. Можно не слишком беспокоиться если банк надежный, но если вы хотите полностью обезопасить ваши средства, следует разделить депозиты на несколько банков, участвующих в программе страхования вкладов и разместить в каждом из них сумму не превышающую 1,4 млн. рублей."
                    let tip = Tip(intro: "У вас есть депозиты суммой более 1,4 млн. рублей. Они не защищены системой страхования вкладов.", teaser: "Подробнее", text: long)
                    self.tips.append(tip)
                    return
                }
            default: break
            }
            
        }
        
        
    }
    
    func fillStocksAndSeeMore(){
        let long = "Приложение анализирует ваши финансы и предлагает варианты, как можно ими распорядиться, чтобы получить дополнительный доход. Укажите все свои финансовые ресурсы: вклады, карты, наличные, металлы и мы покажем вам актуальные советы и идеи."
        let tip = Tip(intro: "Укажите все ваши активы: наличные, вклады, кредиты и прочее и вы увидите здесь новые идеи и советы", teaser: "Подробнее", text: long)
        self.tips.append(tip)
        
    }
    
    func bewareOfForex(){
        let long = "Заинтересовавшись инвестициями и начав искать более подробную информацию о них, вы непременно наткнетесь на массу аггрессивной рекламы Forex-компаний. Мы убедительно призываем вас не пытаться выиграть на валютных спекуляциях, так как скорее всего вы потеряете на них свои деньги."
        let tip = Tip(intro: "Наша задача помочь вам начать инвестировать, но вы должны четко понимать разницу между инвестициями и спекуляциями. В частности мы призываем вас не вкладывать деньги в Forex_⚠️", teaser: "Подробнее", text: long)
        self.tips.append(tip)
        
    }
    
    
    
    
}
