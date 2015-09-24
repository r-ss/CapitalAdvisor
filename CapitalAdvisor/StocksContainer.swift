//
//  StocksContainer.swift
//  Capital
//
//  Created by Alex Antipov on 22/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class StocksContainer {
    
    // MARK: Properties
    var stocks = [Stock]()
    var selectedStockIndex: Int = 0 // я нуб
    
    
    let stocksTypesArray = ["Наличные",         // 0
        "Счёт",             // 1
        "Депозит",          // 2
        "Дебетовая карта",  // 3
        "Кредитная карта",  // 4
        "Актив",            // 5
        "Доход"]            // 6
    
    var numberOfStocksTypes:Int {
        return self.stocksTypesArray.count
    }
    

    // MARK: Functions
    func stocksCount() -> Int {
        return self.stocks.count
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
    
    func setSelectedStockIndex(index:Int){
        self.selectedStockIndex = index
    }
    
    func getSelectedStockIndex() -> Int? {
        return self.selectedStockIndex
    }
    
    // MARK: NSCoding
    func saveStocks() {
        //let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(stocks, toFile: Stock.ArchiveURL.path!)
        //if !isSuccessfulSave {
        //    print("ERROR: Failed to save stocks...")
        //}
    }
    func loadStocks() {
        //print(Stock.ArchiveURL.path!)
        
        //if let archivedStocks = NSKeyedUnarchiver.unarchiveObjectWithFile(Stock.ArchiveURL.path!) as! [Stock]? {
        //    self.stocks += archivedStocks
        //} else {
            loadSampleStocks()
        //}
    }
    
    func loadSampleStocks() {
        
        let stock1 = Stock(type: 0, name: "Наличн.", value: 3290.0, currency:.RUB)!
        let stock2 = Stock(type: 1, name: "Сбер", value: 500000.0, currency:.RUB, percent: 0.125)!
        
        self.stocks += [stock1, stock2]
        
    }
    
}