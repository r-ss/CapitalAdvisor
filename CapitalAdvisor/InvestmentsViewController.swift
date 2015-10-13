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
        
        let total = appDelegate.container.totalStocksValueInCurrency(defaultCurrency)
        let totalCash = appDelegate.container.totalStocksValueOfTypeInCurrency(.Cash, currency: defaultCurrency)
        let totalBank = appDelegate.container.totalStocksValueOfTypeInCurrency(.Bank, currency: defaultCurrency)
        let totalDeposit = appDelegate.container.totalStocksValueOfTypeInCurrency(.Deposit, currency: defaultCurrency)
        let totalDebit = appDelegate.container.totalStocksValueOfTypeInCurrency(.Debit, currency: defaultCurrency)
        let totalCredit = appDelegate.container.totalStocksValueOfTypeInCurrency(.Credit, currency: defaultCurrency)
        let totalAsset = appDelegate.container.totalStocksValueOfTypeInCurrency(.Asset, currency: defaultCurrency)
        let totalStock = appDelegate.container.totalStocksValueOfTypeInCurrency(.Stock, currency: defaultCurrency)
        
        
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
        
        
        addSectionMaybe(totalCash, total: total, text: Type.Cash.pluralTitle)
        addSectionMaybe(totalBank, total: total, text: Type.Bank.pluralTitle)
        addSectionMaybe(totalDeposit, total: total, text: Type.Deposit.pluralTitle)
        addSectionMaybe(totalDebit, total: total, text: Type.Debit.pluralTitle)
        addSectionMaybe(totalCredit, total: total, text: Type.Credit.pluralTitle)
        addSectionMaybe(totalAsset, total: total, text: Type.Asset.pluralTitle)
        addSectionMaybe(totalStock, total: total, text: Type.Stock.pluralTitle)
        
        currentAllocationPieChart.hidden = true
        
    }
    
    var top:CGFloat = 100
    var margin:CGFloat = 20
    
    let labelHeight:CGFloat = 36
    let lineHeight:CGFloat = 2
    let sectionsMargin:CGFloat = 5
    
    
    func addSectionMaybe(part:Double, total:Double, text:String){
        
        let allWidth:CGFloat = self.view.frame.size.width - margin * 2
        let allWidthWithoutMargins:CGFloat = self.view.frame.size.width
        
        if part / total > 0 {
            let label = UILabel.init(frame: CGRect(x:margin, y:top, width: allWidth, height: labelHeight))
            label.text = "\(NSString(format:"%.1f", (part / total) * 100))% — \(text)"
            styleLabel(label)
            self.view.addSubview(label)
            top += labelHeight
            let line = UIView.init(frame: CGRect(x:0, y:top, width: CGFloat(part / total) * allWidthWithoutMargins, height: lineHeight))
            line.backgroundColor = Palette.Accent.color
            self.view.addSubview(line)
            top += lineHeight + sectionsMargin
        }
    }
    
    
    func styleLabel(label:UILabel) {
        label.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        //label.textColor = Palette.Dark.color
        //styleView(label)
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
