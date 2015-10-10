//
//  StocksContainer.swift
//  Capital
//
//  Created by Alex Antipov on 22/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

import RealmSwift


class RealmStock: Object {
    dynamic var name:String = ""
    dynamic var type_int:Int = 0
    dynamic var currency_int:Int = 0
    dynamic var value:Double = 0.0
    dynamic var percent:Double = 0.0
    dynamic var note:String = ""
    dynamic var deposit_due_date:String = ""
}

class RealmIncome: Object {
    dynamic var name:String = ""
    dynamic var currency_int:Int = 0
    dynamic var value:Double = 0.0
    dynamic var note:String = ""
}

//var type:Type = .Cash

//let valueFormat:ValueFormat = ValueFormat()


class StocksContainer {
    
    //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    
    // MARK: Properties
    var stocks = [Stock]()
    var incomes = [Income]()
    
    
    var selectedStockIndex: Int? // я нуб
    var selectedIncomeIndex: Int? // я нуб
    
    let realm = try!Realm()
    
    var totalByCurrencies:[Currency:Double]  {
        var totalRUB:Double = 0.0
        var totalUSD:Double = 0.0
        var totalEUR:Double = 0.0
        for stock in self.stocks {
            switch stock.currency {
            case .USD:
                totalUSD += stock.value
            case .EUR:
                totalEUR += stock.value
            default:
                totalRUB += stock.value
            }
        }
        return [.RUB:totalRUB, .USD:totalUSD, .EUR:totalEUR]
    }
    
    var numberOfStocksTypes:Int {
        return typesArray.count
    }
    
    var stocksCount: Int {
        return self.stocks.count
    }
    
    var incomesCount: Int {
        return self.incomes.count
    }
    
    func totalStocksValueInCurrency(currency:Currency) -> Double {
        var totalValue:Double = 0.0
        for stock in self.stocks {
            totalValue += stock.getValueInCurrency(currency)
        }
        return totalValue
    }
    
    func totalStocksValueOfTypeInCurrency(type:Type, currency:Currency) -> Double {
        var totalValue:Double = 0.0
        for stock in self.stocks {
            if stock.type == type {
                totalValue += stock.getValueInCurrency(currency)
            }
        }
        return totalValue
    }
    
    func addStock(newStock:Stock) {
        self.stocks.append(newStock)
        saveStocks()
    }
    
    func addIncome(newIncome:Income) {
        self.incomes.append(newIncome)
        saveIncomes()
    }
    
    func updateStock(newStock:Stock, atIndex i:Int) {
        self.stocks[i] = newStock
        saveStocks()
    }
    
    func updateIncome(newIncome:Income, atIndex i:Int) {
        self.incomes[i] = newIncome
        saveIncomes()
    }
    
    func removeStockAtIndex(index:Int) {
        //print(index)
        
        if !self.stocks.isEmpty {
            self.stocks.removeAtIndex(index)
            saveStocks()
        }
        
        
    }
    
    func removeIncomeAtIndex(index:Int) {
        self.incomes.removeAtIndex(index)
        saveIncomes()
    }
    
    func rearrangeStock(oldIndex:Int, newIndex:Int) {
        let stock = self.stocks[oldIndex]
        self.stocks.removeAtIndex(oldIndex)
        self.stocks.insert(stock, atIndex: newIndex)
        saveStocks()
    }
    
    func rearrangeIncome(oldIndex:Int, newIndex:Int) {
        let income = self.incomes[oldIndex]
        self.incomes.removeAtIndex(oldIndex)
        self.incomes.insert(income, atIndex: newIndex)
        saveIncomes()
    }

    func setSelectedStockIndex(index:Int){
        self.selectedStockIndex = index
    }
    
    func getSelectedStockIndex() -> Int? {
        let index = self.selectedStockIndex
        self.selectedStockIndex = nil
        return index
    }
    
    func setSelectedIncomeIndex(index:Int){
        self.selectedIncomeIndex = index
    }
    
    func getSelectedIncomeIndex() -> Int? {
        let index = self.selectedIncomeIndex
        self.selectedIncomeIndex = nil
        return index
    }
    

    // MARK: NSCoding
    func saveIncomes() {
        saveStocks()
    }
    
    
    func saveStocks() {
        print("Stock Container > saveStocks")
        
        // Delete all objects from the realm
        realm.write {
            self.realm.deleteAll()
        }
     
        for stock in stocks {
            let rs:RealmStock = RealmStock()
            rs.name = stock.name
            rs.type_int = stock.type.id
            rs.currency_int = stock.currency.id
            rs.value = stock.value
            rs.percent = stock.percent
            rs.note = stock.note
            
            if let dddate:NSDate = stock.depositDueDate {
                rs.deposit_due_date = dddate.convertedToString!
            } else {
                rs.deposit_due_date = ""
            }
            
            realm.write {
                self.realm.add(rs)
            }
        }
        
        for income in incomes {
            let ri:RealmIncome = RealmIncome()
            ri.name = income.name
            ri.currency_int = income.currency.id
            ri.value = income.value
            ri.note = income.note
            
            realm.write {
                self.realm.add(ri)
            }
        }
    }
    func loadStocks() {
        
        //loadSampleStocks()
        
        print("Stock Container > loadStocks")
        let realmStocks = try!Realm().objects(RealmStock)
        let realmIncomes = try!Realm().objects(RealmIncome)
        //print(realmStocks)
        for rs in realmStocks {
            //print(rs.value)
            
            var dddate:NSDate?
            if !rs.deposit_due_date.isEmpty {
                dddate = rs.deposit_due_date.convertedToDate
            }
            
            let stock = Stock(type: Type(id: rs.type_int),
                name: rs.name,
                value: rs.value,
                currency: Currency(id: rs.currency_int),
                percent: rs.percent,
                note: rs.note,
                depositDueDate: dddate)!
            self.stocks += [stock]
        }
        
        for ri in realmIncomes {
            //print(rs.value)
            
            let income = Income(name: ri.name,
                value: ri.value,
                currency: Currency(id: ri.currency_int),
                note: ri.note)!
            self.incomes += [income]
        }
        
    }
    
    func loadExampleStockAtFirstRun() {
        let stock1 = Stock(type: .Cash, name: "Наличные", value: 15000.0, currency:.RUB)!
        let stock2 = Stock(type: .Deposit, name: "Сбербанк", value: 250000.0, currency:.RUB, percent: 0.12)!
        self.stocks += [stock1, stock2]
        saveStocks()
    }
    
    func loadSampleStocks() {
        print("Stock Container > loadSampleStocks")

        let stock1 = Stock(type: .Cash, name: "Наличн.", value: 3290.0, currency:.RUB)!
        let stock2 = Stock(type: .Deposit, name: "Сбер", value: 500000.0, currency:.RUB, percent: 0.125)!
        self.stocks += [stock1, stock2]
        let income1 = Income(name: "Пенсия", value: 13200.0, currency:.RUB)!
        let income2 = Income(name: "Аренда", value: 99.0, currency:.USD)!
        self.incomes += [income1, income2]
    }
    
}