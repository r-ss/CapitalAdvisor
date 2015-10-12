//
//  InvestmentsViewController.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 12/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit
import Charts


class InvestmentsViewController: UIViewController {

    @IBOutlet weak var currentAllocationPieChart: PieChartView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries = [ChartDataEntry]()
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "Stocks")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        //let totalStocksValue:Double = 500
        currentAllocationPieChart.data = pieChartData
        currentAllocationPieChart.descriptionText = ""
        currentAllocationPieChart.usePercentValuesEnabled = false
        currentAllocationPieChart.holeTransparent = true
        currentAllocationPieChart.centerTextFont = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        currentAllocationPieChart.centerText = "75% | 25%"
        currentAllocationPieChart.legend.enabled = false
        currentAllocationPieChart.rotationEnabled = false
        currentAllocationPieChart.holeRadiusPercent = 0.80
        pieChartDataSet.drawValuesEnabled = false
        currentAllocationPieChart.drawSliceTextEnabled = false
        currentAllocationPieChart.userInteractionEnabled = false
        var colors = [UIColor]()
        for stock in appDelegate.container.stocks {
            colors.append(stock.color)
        }
        pieChartDataSet.colors = colors
    }
    
    func setData(){
        var names = [String]()
        var values = [Double]()
        //totalStocksValue = 0.0
        //let totalStocksCount:Int = appDelegate.container.stocksCount
        
        
        let totalCash = appDelegate.container.totalStocksValueOfTypeInCurrency(.Cash, currency: .RUB)
        let totalBank = appDelegate.container.totalStocksValueOfTypeInCurrency(.Bank, currency: .RUB)
        let totalDeposit = appDelegate.container.totalStocksValueOfTypeInCurrency(.Deposit, currency: .RUB)
        let totalDebit = appDelegate.container.totalStocksValueOfTypeInCurrency(.Debit, currency: .RUB)
        let totalCredit = appDelegate.container.totalStocksValueOfTypeInCurrency(.Credit, currency: .RUB)
        let totalAsset = appDelegate.container.totalStocksValueOfTypeInCurrency(.Asset, currency: .RUB)
        let totalStock = appDelegate.container.totalStocksValueOfTypeInCurrency(.Stock, currency: .RUB)
        
        
        names.append(Type.Cash.title)
        values.append(totalCash)
        names.append(Type.Bank.title)
        values.append(totalBank)
        names.append(Type.Deposit.title)
        values.append(totalDeposit)
        names.append(Type.Debit.title)
        values.append(totalDebit)
        names.append(Type.Credit.title)
        values.append(totalCredit)
        names.append(Type.Asset.title)
        values.append(totalAsset)
        names.append(Type.Stock.title)
        values.append(totalStock)
        
        setChart(names, values: values)
        //self.tableStocks.reloadData();
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
