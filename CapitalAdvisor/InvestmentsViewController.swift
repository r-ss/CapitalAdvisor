//
//  InvestmentsViewController.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 12/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit
//import Charts


class InvestmentsViewController: UIViewController {


    var scrollView: UIScrollView!
    
    var top:CGFloat = 0
    
    let margin:CGFloat = 20
    let labelHeight:CGFloat = 36
    let lineHeight:CGFloat = 2
    let sectionsMargin:CGFloat = 5
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.view.backgroundColor = Palette.White.color        
        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = Palette.White.color
        
        
        //setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        top = 100
        
        setData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.scrollView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
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
        
        //setChart(names, values: values)
        //self.tableStocks.reloadData();
        
        
        let allocationLabel = UILabel.init(frame: CGRect(x:margin, y:top, width: self.view.frame.size.width - margin * 2, height: labelHeight * 2))
        allocationLabel.numberOfLines = 0
        allocationLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        allocationLabel.text = "Ваши активы распределены следующим образом:"
        self.scrollView.addSubview(allocationLabel)
        top += labelHeight * 2
        
        addSectionMaybe(totalCash, total: total, text: Type.Cash.pluralTitle)
        addSectionMaybe(totalBank, total: total, text: Type.Bank.pluralTitle)
        addSectionMaybe(totalDeposit, total: total, text: Type.Deposit.pluralTitle)
        addSectionMaybe(totalDebit, total: total, text: Type.Debit.pluralTitle)
        addSectionMaybe(totalCredit, total: total, text: Type.Credit.pluralTitle)
        addSectionMaybe(totalAsset, total: total, text: Type.Asset.pluralTitle)
        addSectionMaybe(totalStock, total: total, text: Type.Stock.pluralTitle)
        
        /*
        
        let lineChart = LineChartView()
        lineChart.frame = CGRect(x:10, y:top, width: self.view.frame.size.width - 20, height: 200)
        self.scrollView.addSubview(lineChart)
        
        var dataEntries = [ChartDataEntry]()
        for i in 0...10 {
            let dataEntry = ChartDataEntry(value: Double(i)*(1.12*Double(i)), xIndex: i)
            dataEntries.append(dataEntry)
        }
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Stocks")
        chartDataSet.drawCubicEnabled = true
        chartDataSet.drawValuesEnabled = true
        chartDataSet.drawCirclesEnabled = false
        let chartData = LineChartData(xVals: dataEntries, dataSet: chartDataSet)
        
        lineChart.data = chartData
        
        
        lineChart.descriptionText = ""
        //lineChart.usePercentValuesEnabled = false
        //lineChar
        //pieChartView.centerTextFont = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        //pieChartView.centerText = valueFormat.format(totalStocksValue, currency: defaultCurrency, adaptive: true) as String
        lineChart.legend.enabled = false
        lineChart.gridBackgroundColor = UIColor.whiteColor()
        
        lineChart.drawGridBackgroundEnabled = false
        lineChart.xAxis.enabled = false

        
        //lineChart.drawCubic.enabled = true
        //pieChartView.rotationEnabled = false
        //pieChartView.holeRadiusPercent = 0.90
        //lineChart.drawValuesEnabled = true
        //pieChartView.drawSliceTextEnabled = false
        lineChart.userInteractionEnabled = false
        
        
        
        
        top += 200
        */
        
        top += 70
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, top)
        
    }
    
    
    func addSectionMaybe(part:Double, total:Double, text:String){
        
        let allWidth:CGFloat = self.view.frame.size.width - margin * 2
        let allWidthWithoutMargins:CGFloat = self.view.frame.size.width
        
        if part / total > 0 {
            let label = UILabel.init(frame: CGRect(x:margin, y:top, width: allWidth, height: labelHeight))
            let p:String = NSString(format:"%.1f", ((part / total) * 100)) as String
            label.text = "\(p)% — \(text)"
            styleLabel(label)
            self.scrollView.addSubview(label)
            top += labelHeight
            let line = UIView.init(frame: CGRect(x:0, y:top, width: CGFloat(part / total) * allWidthWithoutMargins, height: lineHeight))
            line.backgroundColor = Palette.Accent.color
            self.scrollView.addSubview(line)
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
