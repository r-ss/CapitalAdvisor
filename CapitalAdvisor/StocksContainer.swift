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
}

//let typeNamesArray = ["Наличные", "Счёт", "Депозит", "Дебетовая карта", "Кредитная карта", "Актив", "Доход"]

var type:Type = .Cash
//var type_name:String {
//    switch type {
//    case .Bank:
//        return typeNamesArray[1]
//    case .Deposit:
//        return typeNamesArray[2]
//    case .Debit:
//        return typeNamesArray[3]
//    case .Credit:
//        return typeNamesArray[4]
//    case .Asset:
//        return typeNamesArray[5]
//    case .Income:
//        return typeNamesArray[6]
//    default:
//        return typeNamesArray[0]
//    }
//}

var name: String = ""
var value: Double = 0.0
var currency:Currency = .RUB
var percent: Double = 0.0
var color: UIColor = UIColor.whiteColor()

let valueFormat:ValueFormat = ValueFormat()!
let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate




class StocksContainer {
    
    // MARK: Properties
    var stocks = [Stock]()
    var selectedStockIndex: Int = 0 // я нуб
    
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
    
    func totalStocksValueInCurrency(currency:Currency) -> Double {
        var totalValue:Double = 0.0
        for stock in self.stocks {
            totalValue += stock.getValueInCurrency(currency)
        }
        return totalValue
    }
    
    func addStock(newStock:Stock) {
        self.stocks.append(newStock)
        saveStocks()
    }
    
    func updateStock(newStock:Stock, atIndex i:Int) {
        self.stocks[i] = newStock
        saveStocks()
    }
    
    func removeStockAtIndex(index:Int) {
        self.stocks.removeAtIndex(index)
        saveStocks()
    }
    
    func rearrangeStock(oldIndex:Int, newIndex:Int) {
        let stock = self.stocks[oldIndex]
        self.stocks.removeAtIndex(oldIndex)
        self.stocks.insert(stock, atIndex: newIndex)
        saveStocks()
    }
    
    func setSelectedStockIndex(index:Int){
        self.selectedStockIndex = index
    }
    
    func getSelectedStockIndex() -> Int? {
        return self.selectedStockIndex
    }
    
    // MARK: NSCoding
    func saveStocks() {
        print("Stock Container > saveStocks")
        
        // Delete all objects from the realm
        realm.write {
            self.realm.deleteAll()
        }
     
        for stock in stocks {
            let rs:RealmStock = RealmStock()
            rs.name = stock.name
            rs.type_int = typeToInt(stock.type)
            rs.currency_int = currencyToInt(stock.currency)
            rs.value = stock.value
            rs.percent = stock.percent
            
            realm.write {
                self.realm.add(rs)
            }
        }
    }
    func loadStocks() {
        print("Stock Container > loadStocks")
        let realmStocks = try!Realm().objects(RealmStock)
        //print(realmStocks)
        for rs in realmStocks {
            //print(rs.value)
            let stock = Stock(type: intToType(rs.type_int),
                name: rs.name,
                value: rs.value,
                currency: intToCurrency(rs.currency_int),
                percent: rs.percent)!
            self.stocks += [stock]
        }
    }
    
    func loadSampleStocks() {
        
        let stock1 = Stock(type: .Cash, name: "Наличн.", value: 3290.0, currency:.RUB)!
        let stock2 = Stock(type: .Deposit, name: "Сбер", value: 500000.0, currency:.RUB, percent: 0.125)!
        
        self.stocks += [stock1, stock2]
        
    }
    
}