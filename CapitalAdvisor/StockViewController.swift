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
   
    var stock: Stock?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if editing an existing Stock.
        if let stock = stock {
            //navigationItem.title = stocksTypesArray[stock.type]
            navigationItem.title = stock.type_name
            nameLabel.text = stock.name
            
            let valueFormattedString:String = appDelegate.valueFormat.format(stock.value, currency: stock.currency) as String
            let percentsString:String = String(stock.percent * 100)
            
            //valueLabel.text = "\(stock.value)"
            valueLabel.text = valueFormattedString
            percentsLabel.text = "@ \(percentsString)% годовых"
            
        } else {
            print(">>> NO STOCK <<< (StockViewController)")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToStockDetails(sender: UIStoryboardSegue) {
        print("> StockViewController > unwindToStockDetails")
        if let sourceViewController = sender.sourceViewController as? StockEditViewController, stock = sourceViewController.stock {
            
            self.stock = stock
            
            print(parentViewController)

            
            self.viewDidLoad()
            
            //print(stock.value)
            
            if let selectedStockIndex:Int = appDelegate.container.getSelectedStockIndex()! {
                appDelegate.container.updateStock(stock, atIndex: selectedStockIndex)
            }
           
        
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditStock" {
            let stockEditViewController = segue.destinationViewController as! StockEditViewController
            stockEditViewController.stock = self.stock
            
        } else {
            print("> StockViewController > prepareForSegue")
        }
    }
    
}

