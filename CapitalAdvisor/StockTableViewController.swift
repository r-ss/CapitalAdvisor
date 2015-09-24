//
//  StockTableViewController.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

import Charts



class StockTableViewController: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var totalsLabel: UILabel!
    @IBOutlet weak var currenciesLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet var tableStocks: UITableView!
    @IBOutlet weak var devidendsLabel: UILabel!
    
    let valueFormat:ValueFormat = ValueFormat()!
    //var stocks = [Stock]()
    var totalStocksValue:Double = 0.0
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //var container:StocksContainer?
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //var seguesBlocked:Bool = false // noobish solution to prevent double fire segue
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("viewDidLoad")
        
        //container = AppDelegate.container
        
        
        //appDelegate.stocksTableViewControler = self
        
 
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "exchangeRatesLoaded:", name: "Notification.exchangeRatesLoaded", object: nil)
        
        //loadSampleStocks()
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("viewWillAppear")
        showInitialExchangeRates()
        updateData()
        //self.seguesBlocked = false
    }
    
//    override func viewWillDisappear(animated: Bool) {
//        self.seguesBlocked = true
//    }
    
    
    func showInitialExchangeRates(){
        let exchangeRates:ExchangeRates = appDelegate.exchangeRates
        let USD = NSString(format:"%.2f", exchangeRates.USDRUR)
        let EUR = NSString(format:"%.2f", exchangeRates.EURRUR)
        currenciesLabel.text = "USD: \(USD), EUR: \(EUR)"
    }
    
    func exchangeRatesLoaded(notification: NSNotification){
        let exchangeRates:ExchangeRates = appDelegate.exchangeRates
        let USD = NSString(format:"%.2f", exchangeRates.USDRUR)
        let EUR = NSString(format:"%.2f", exchangeRates.EURRUR)
        currenciesLabel.text = "USD: \(USD), EUR: \(EUR)"
        updateData()
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries = [ChartDataEntry]()
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Stocks")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        pieChartView.descriptionText = ""
        pieChartView.usePercentValuesEnabled = false
        pieChartView.holeTransparent = true
        pieChartView.centerTextFont = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        pieChartView.centerText = valueFormat.format(totalStocksValue, currency: appDelegate.defaultCurrency, adaptive: true) as String
        pieChartView.legend.enabled = false
        pieChartView.rotationEnabled = false
        pieChartView.holeRadiusPercent = 0.90
        pieChartDataSet.drawValuesEnabled = false
        pieChartView.drawSliceTextEnabled = false
        pieChartView.userInteractionEnabled = false
        
        
        //var colors: [UIColor] = []
        var colors = [UIColor]()
        //var i = 1;
        for stock in appDelegate.container.stocks {
            colors.append(stock.color)
            //i+=1
        }
        pieChartDataSet.colors = colors
    }
    
    func updateData(){
        //print(">>> UPDATE DATA")
        var totalRUR:Double = 0.0
        var totalUSD:Double = 0.0
        var totalEUR:Double = 0.0
        
        var names = [String]()
        var values = [Double]()
        totalStocksValue = 0.0
        let totalStocksCount:Int = appDelegate.container.stocksCount()
        
        var i = 0;
        for stock in appDelegate.container.stocks {
            
            let colorTools:ColorTools = ColorTools()
            stock.color = colorTools.stepGradientColorForIndex(i, total: totalStocksCount)

            
            
            names.append(stock.name)
            values.append(Double(stock.getValueInDefaultCurrency()))
            totalStocksValue += Double(stock.getValueInDefaultCurrency())
            
            switch stock.currency {
            case 1:
                totalUSD += stock.value
            case 2:
                totalEUR += stock.value
            default:
                totalRUR += stock.value
            }
            
            i+=1
        }
        
        // if no stocks...
        if i == 0 {
            names.append("no")
            values.append(0.0)
        }
        
        
        totalsLabel.text = "\(valueFormat.format(totalRUR, currency: 0))    \(valueFormat.format(totalUSD, currency: 1))    \(valueFormat.format(totalEUR, currency: 2))"
        
        updateDevidends()
        
        setChart(names, values: values)
        self.tableStocks.reloadData();
                
        if totalStocksCount > 0 {
            self.navigationItem.leftBarButtonItem = self.editButtonItem()
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
    }
    
    func updateDevidends(){
        var totalRUR:Double = 0.0
        var totalUSD:Double = 0.0
        var totalEUR:Double = 0.0
        
        for stock in appDelegate.container.stocks {
            let devident:Double = stock.value * stock.percent
            switch stock.currency {
            case 1:
                totalUSD += devident
            case 2:
                totalEUR += devident
            default:
                totalRUR += devident
            }
        }
        
        let exchangeRates:ExchangeRates = appDelegate.exchangeRates
        let totalUSDinRoubles:Double = totalUSD * exchangeRates.USDRUR
        let totalEURinRoubles:Double = totalEUR * exchangeRates.EURRUR
        
        var totalDevidents: Double
        switch appDelegate.defaultCurrency {
        case 1:
            totalDevidents = (totalRUR + totalUSDinRoubles + totalEURinRoubles) / exchangeRates.USDRUR
        case 2:
            totalDevidents = (totalRUR + totalUSDinRoubles + totalEURinRoubles) / exchangeRates.EURRUR
        default:
            totalDevidents = totalRUR + totalUSDinRoubles + totalEURinRoubles
        }
        
        let inMonth = totalDevidents / 12
        let inDay = totalDevidents / 365
        
        let totalDevidentsString:NSString = valueFormat.format(totalDevidents, currency: appDelegate.defaultCurrency) as String
        let inMonthString:NSString = valueFormat.format(inMonth, currency: appDelegate.defaultCurrency) as String
        let inDayString:NSString = valueFormat.format(inDay, currency: appDelegate.defaultCurrency) as String
        
        devidendsLabel.text = "+ \(totalDevidentsString) в год\n+ \(inMonthString) в месяц\n+ \(inDayString) в день"
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.container.stocksCount()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        // Configure the cell...
        
        let cellIdentifier = "StockTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StockTableViewCell

        let stock = appDelegate.container.stocks[indexPath.row]
        
        
        cell.nameLabel.text = stock.name
        cell.valueLabel.text = stock.getDisplayValue() as String
        cell.percentLabel.text = "\(stock.type_name) \(stock.getDisplayPercent() as String)"
        cell.profitLabel.text = stock.getDisplayMonthlyReturn() as String
        cell.colorRectangleView.backgroundColor = stock.color

        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            appDelegate.container.removeStockAtIndex(indexPath.row)
            appDelegate.container.saveStocks()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        updateData()
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("> StockTableViewController > prepareForSegue. Segue identifier: \(segue.identifier)")
        
        if segue.identifier == "ShowDetail" {
            let stockDetailViewController = segue.destinationViewController as! StockViewController
            // Get the cell that generated this segue.
            if let selectedStockCell = sender as? StockTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedStockCell)!
                
                let selectedStock = appDelegate.container.stocks[indexPath.row]
                
                appDelegate.container.setSelectedStockIndex(indexPath.row)
                
                stockDetailViewController.stock = selectedStock
                //stockDetailViewController.selectedStock = selectedStock.type
            }
        }
        else if segue.identifier == "AddItem" {
            //print("Adding new stock.", terminator: "")
        }
    }
    
    
    @IBAction func unwindToStockList(sender: UIStoryboardSegue) {
        print("> StockTableViewController > unwindToStockList")
        if let sourceViewController = sender.sourceViewController as? StockEditViewController, stock = sourceViewController.stock {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing stock.
                //stocks[selectedIndexPath.row] = stock
                appDelegate.container.updateStock(stock, atIndex: selectedIndexPath.row)
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {                
                // Add a new stock.
                let newIndexPath = NSIndexPath(forRow: appDelegate.container.stocksCount(), inSection: 0)
                appDelegate.container.addStock(stock)
                //stocks.append(stock)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            updateData()
            // Save stocks.
            appDelegate.container.saveStocks()
        }
    }
    
}
