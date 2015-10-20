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
        
        
//        self.view.backgroundColor = Palette.White.color        
//        self.scrollView = UIScrollView()
//        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        //self.scrollView.delegate = self
//        self.view.addSubview(self.scrollView)
//        self.scrollView.backgroundColor = Palette.Light.color
//        
        
        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.scrollView.backgroundColor = Palette.White.color
        self.view = self.scrollView
        
        
        //setData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        top = 0
        
        setData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.scrollView.subviews.forEach({
            // Preventint removing scroll indicators from UIScrollView
            if !$0.isKindOfClass(UIImageView){
                $0.removeFromSuperview()
            }
            
        })
        //self.scrollView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        //view.subviews.map({ $0.removeFromSuperview() }) // this returns modified array
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
        
        
        var totalRUB:Double = 0
        var totalUSD:Double = 0
        var totalEUR:Double = 0
        
        for stock in appDelegate.container.stocks {
            switch stock.currency {
            case .RUB: totalRUB += stock.getValueInCurrency(defaultCurrency)
            case .USD: totalUSD += stock.getValueInCurrency(defaultCurrency)
            case .EUR: totalEUR += stock.getValueInCurrency(defaultCurrency)
            }
        }
        
        let totalAll:Double = totalRUB + totalUSD + totalEUR
        
//        let percentRUB:Double = totalRUB / totalAll
//        let percentUSD:Double = totalUSD / totalAll
//        let percentEUR:Double = totalEUR / totalAll
        
        
        let currenciesLabel = UILabel.init(frame: CGRect(x:margin, y:top, width: self.view.frame.size.width - margin * 2, height: labelHeight * 1))
        currenciesLabel.numberOfLines = 1
        currenciesLabel.font = UIFont.systemFontOfSize(14, weight: UIFontWeightRegular)
        currenciesLabel.text = "Валюты:"
        self.scrollView.addSubview(currenciesLabel)
        top += labelHeight
        
        addSectionMaybe(totalRUB, total: totalAll, text: Currency.RUB.pluralTitle)
        addSectionMaybe(totalUSD, total: totalAll, text: Currency.USD.pluralTitle)
        addSectionMaybe(totalEUR, total: totalAll, text: Currency.EUR.pluralTitle)
        
        
        
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
