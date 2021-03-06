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
    
    let valueFormat:ValueFormat = ValueFormat()
    //var stocks = [Stock]()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //var container:StocksContainer?
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //var seguesBlocked:Bool = false // noobish solution to prevent double fire segue
       
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "exchangeRatesLoaded:", name: "Notification.exchangeRatesLoaded", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        showInitialExchangeRates()
        updateData()
    }

    
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
        let totalStocksValue:Double = appDelegate.container.totalStocksValueInCurrency(defaultCurrency)
        pieChartView.data = pieChartData
        pieChartView.descriptionText = ""
        pieChartView.usePercentValuesEnabled = false
        pieChartView.holeTransparent = true
        pieChartView.centerTextFont = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        pieChartView.centerText = valueFormat.format(totalStocksValue, currency: defaultCurrency, adaptive: true) as String
        pieChartView.legend.enabled = false
        pieChartView.rotationEnabled = false
        pieChartView.holeRadiusPercent = 0.90
        pieChartDataSet.drawValuesEnabled = false
        pieChartView.drawSliceTextEnabled = false
        pieChartView.userInteractionEnabled = false
        var colors = [UIColor]()
        for stock in appDelegate.container.stocks {
            colors.append(stock.color)
        }
        pieChartDataSet.colors = colors
    }
    
    func updateData(){
        var names = [String]()
        var values = [Double]()
        //totalStocksValue = 0.0
        let totalStocksCount:Int = appDelegate.container.stocksCount
        
        var i = 0
        for stock in appDelegate.container.stocks {
            let colorTools:ColorTools = ColorTools()
            stock.color = colorTools.stepGradientColorForIndex(i, total: totalStocksCount)

            names.append(stock.name)
            values.append(Double(stock.getValueInDefaultCurrency()))
            //totalStocksValue += Double(stock.getValueInDefaultCurrency())
        
            i+=1
        }
        
        // if no stocks...
        if i == 0 {
            names.append("no")
            values.append(0.0)
        }
        
        let totalRUB:Double = appDelegate.container.totalByCurrencies[.RUB]!
        let totalUSD:Double = appDelegate.container.totalByCurrencies[.USD]!
        let totalEUR:Double = appDelegate.container.totalByCurrencies[.EUR]!
        totalsLabel.text = "\(valueFormat.format(totalRUB, currency: .RUB))    \(valueFormat.format(totalUSD, currency: .USD))    \(valueFormat.format(totalEUR, currency: .EUR))"
        
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
            case .USD:
                totalUSD += devident
            case .EUR:
                totalEUR += devident
            default:
                totalRUR += devident
            }
        }
        
        for income in appDelegate.container.incomes {
            let devident:Double = income.value * 12
            switch income.currency {
            case .USD:
                totalUSD += devident
            case .EUR:
                totalEUR += devident
            default:
                totalRUR += devident
            }
        }
        
        let exchangeRates:ExchangeRates = appDelegate.exchangeRates
        let totalUSDinRoubles:Double = totalUSD * exchangeRates.USDRUR
        let totalEURinRoubles:Double = totalEUR * exchangeRates.EURRUR
        
        var totalDevidents: Double
        switch defaultCurrency {
        case .USD:
            totalDevidents = (totalRUR + totalUSDinRoubles + totalEURinRoubles) / exchangeRates.USDRUR
        case .EUR:
            totalDevidents = (totalRUR + totalUSDinRoubles + totalEURinRoubles) / exchangeRates.EURRUR
        default:
            totalDevidents = totalRUR + totalUSDinRoubles + totalEURinRoubles
        }
        
        let inMonth = totalDevidents / 12
        let inDay = totalDevidents / 365
        
        let totalDevidentsString:NSString = valueFormat.format(totalDevidents, currency: defaultCurrency) as String
        let inMonthString:NSString = valueFormat.format(inMonth, currency: defaultCurrency) as String
        let inDayString:NSString = valueFormat.format(inDay, currency: defaultCurrency) as String
        
        devidendsLabel.text = "+ \(totalDevidentsString) в год\n+ \(inMonthString) в месяц\n+ \(inDayString) в день"
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 2
        /*
        if appDelegate.container.incomesCount >= 1 {
            return 2
        } else {
            return 1
        }
*/
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return appDelegate.container.stocksCount
        case 1: return appDelegate.container.incomesCount
        default: return 0
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Активы"
        case 1: return "Доходы"
        default: return ""
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        // Configure the cell...
        
        let cellIdentifier = "StockTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StockTableViewCell

        if indexPath.section == 0 {
            let stock = appDelegate.container.stocks[indexPath.row]
            cell.nameLabel.text = stock.name
            cell.valueLabel.text = stock.formattedValue
            cell.percentLabel.text = stock.infoText
            cell.profitLabel.text = stock.formattedDevidendMonth
            cell.colorRectangleView.backgroundColor = stock.color
        }
        
        if indexPath.section == 1 {
            let income = appDelegate.container.incomes[indexPath.row]
            cell.nameLabel.text = income.name
            cell.valueLabel.text = income.formattedValue
            cell.percentLabel.text = "Доход"
            cell.profitLabel.text = "в месяц"
            cell.colorRectangleView.backgroundColor = UIColor.whiteColor()
        }
        
        
        
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
            
            switch indexPath.section {
            case 0: appDelegate.container.removeStockAtIndex(indexPath.row)
            case 1: appDelegate.container.removeIncomeAtIndex(indexPath.row)
            default: break
            }

            //if appDelegate.container.incomesCount == 0 {
            //    tableView.deleteSections(NSIndexSet(index: 1), withRowAnimation: .Fade)
            //}
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        updateData()
    }
    
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
    
        
        if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
            var row:Int = 0
            if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
                row = tableView.numberOfRowsInSection(sourceIndexPath.section) - 1
            }
            return NSIndexPath(forRow: row, inSection:sourceIndexPath.section)
        }
        
        return proposedDestinationIndexPath
        
        
    }
    
   
    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        switch fromIndexPath.section {
        case 0: appDelegate.container.rearrangeStock(fromIndexPath.row, newIndex: toIndexPath.row)
        case 1: appDelegate.container.rearrangeIncome(fromIndexPath.row, newIndex: toIndexPath.row)
        default: break
        }
        
        
        
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("> StockTableViewController > prepareForSegue. Segue identifier: \(segue.identifier)")
        
        if segue.identifier == "ShowDetail" {
            let stockDetailViewController = segue.destinationViewController as! StockViewController
            // Get the cell that generated this segue.
            if let selectedStockCell = sender as? StockTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedStockCell)!
                
                switch indexPath.section {
                case 0:
                    let selectedStock = appDelegate.container.stocks[indexPath.row]
                    stockDetailViewController.stock = selectedStock
                    appDelegate.container.setSelectedStockIndex(indexPath.row)
                case 1:
                    let selectedIncome = appDelegate.container.incomes[indexPath.row]
                    stockDetailViewController.income = selectedIncome
                    appDelegate.container.setSelectedIncomeIndex(indexPath.row)
                default: break
                }
                
               
                
                //appDelegate.container.setSelectedStockIndex(indexPath.row)
                
                
                //stockDetailViewController.selectedStock = selectedStock.type
            }
        }
        else if segue.identifier == "AddItem" {
            //print("Adding new stock.", terminator: "")
        }
    }
    
    
    @IBAction func unwindToStockList(sender: UIStoryboardSegue) {
        print("> StockTableViewController > unwindToStockList")
        if let sourceViewController = sender.sourceViewController as? StockEditViewController {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                print("AA")
                // Update an existing stock.
                if let stock = sourceViewController.stock {
                    appDelegate.container.updateStock(stock, atIndex: selectedIndexPath.row)
                }
                if let income = sourceViewController.income {
                    appDelegate.container.updateIncome(income, atIndex: selectedIndexPath.row)
                }
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            } else {
                print("BB")
                // Add a new stock.
                
                
                //let income = sourceViewController.income
                
                if let stock = sourceViewController.stock {
                    let newIndexPath = NSIndexPath(forRow: appDelegate.container.stocksCount, inSection: 0)
                    appDelegate.container.addStock(stock)
                    //stocks.append(stock)
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
                
                if let income = sourceViewController.income {
                    let newIndexPath = NSIndexPath(forRow: appDelegate.container.incomesCount, inSection: 1)
                    appDelegate.container.addIncome(income)
                    //stocks.append(stock)
                    tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
                }
            }
            updateData()
            // Save stocks.
            //appDelegate.container.saveStocks()
        }
    }
    
}
