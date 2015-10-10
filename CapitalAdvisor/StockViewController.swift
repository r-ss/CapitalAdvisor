//
//  StockViewController.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit


class StockViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var percentsLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
   
    var stock: Stock?
    var income: Income?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {        
        // Set up views if editing an existing Stock.
        if let stock = stock {
            navigationItem.title = stock.type.title
            nameLabel.text = stock.name
            let valueFormattedString:String = appDelegate.valueFormat.format(stock.value, currency: stock.currency) as String
            let percentsString:String = String(stock.percent * 100)
            valueLabel.text = valueFormattedString
            percentsLabel.text = "@ \(percentsString)% годовых"
            
            let formattedPercentInAssets = NSString(format:"%.2f", stock.getPercentInTotalStocksValue() * 100)
            
            var inOtherCurrencies:String = ""
            
            let RUB = ValueFormat().format(stock.getValueInCurrency(.RUB), currency: .RUB)
            let USD = ValueFormat().format(stock.getValueInCurrency(.USD), currency: .USD)
            let EUR = ValueFormat().format(stock.getValueInCurrency(.EUR), currency: .EUR)
            
            switch stock.currency {
            case .RUB:
                inOtherCurrencies = "\(USD)\n\(EUR)"
            case .USD:
                inOtherCurrencies = "\(RUB)\n\(EUR)"
            case .EUR:
                inOtherCurrencies = "\(RUB)\n\(USD)"
            }
            
            infoLabel.text = "\(formattedPercentInAssets)% от активов\n\n\(inOtherCurrencies)\n\n\(stock.formattedDevidendYear)\n\(stock.formattedDevidendMonth)\n\(stock.formattedDevidendDay)"
            
            //infoLabel.text += "f"
            
            
        }
        
        
        if let income = income {
            navigationItem.title = income.name
            nameLabel.text = income.name
            let valueFormattedString:String = appDelegate.valueFormat.format(income.value, currency: income.currency) as String
            //let percentsString:String = String(stock.percent * 100)
            valueLabel.text = valueFormattedString
            percentsLabel.text = ""
            
           //let formattedPercentInAssets = NSString(format:"%.2f", stock.getPercentInTotalStocksValue() * 100)
            
            var inOtherCurrencies:String = ""
            
            let RUB = ValueFormat().format(income.getValueInCurrency(.RUB), currency: .RUB)
            let USD = ValueFormat().format(income.getValueInCurrency(.USD), currency: .USD)
            let EUR = ValueFormat().format(income.getValueInCurrency(.EUR), currency: .EUR)
            
            switch income.currency {
            case .RUB:
                inOtherCurrencies = "\(USD)\n\(EUR)"
            case .USD:
                inOtherCurrencies = "\(RUB)\n\(EUR)"
            case .EUR:
                inOtherCurrencies = "\(RUB)\n\(USD)"
            }
            
            infoLabel.text = "\(inOtherCurrencies)"
            
            //infoLabel.text += "f"
            
            
        }
        
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToStockDetails(sender: UIStoryboardSegue) {
        print("> StockViewController > unwindToStockDetails")
        if let sourceViewController = sender.sourceViewController as? StockEditViewController {
            
            self.stock = sourceViewController.stock
            self.income = sourceViewController.income
            
            //print(parentViewController)

            self.viewDidLoad()
            
            
            if let selectedStockIndex:Int = appDelegate.container.getSelectedStockIndex() {
                print("stock \(selectedStockIndex)")
                if let stock = self.stock {
                    appDelegate.container.updateStock(stock, atIndex: selectedStockIndex)
                }
                
            }
            
            if let selectedIncomeIndex:Int = appDelegate.container.getSelectedIncomeIndex() {
                print("income \(selectedIncomeIndex)")
               
                if let income = self.income {
                    print("DADADA")
                     appDelegate.container.updateIncome(income, atIndex: selectedIncomeIndex)
                }
            }
            
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditStock" {
            let stockEditViewController = segue.destinationViewController as! StockEditViewController
            stockEditViewController.stock = self.stock
            stockEditViewController.income = self.income
            
            if let _ = self.stock {
                stockEditViewController.selectedType = self.stock!.type
            } else {
                stockEditViewController.selectedType = Type.Income
            }
            
            
        } else {
            print("> StockViewController > prepareForSegue")
        }
    }
    
}

