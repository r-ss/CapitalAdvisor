//
//  SettingsViewController.swift
//  Capital
//
//  Created by Alex Antipov on 21/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultCurrencyControl: UISegmentedControl!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        
        if let defaultCurrency = appDelegate.userDefaults.objectForKey("defaultCurrency") as? Int {
            defaultCurrencyControl.selectedSegmentIndex = defaultCurrency
        }
        
        defaultCurrencyControl.addTarget(self, action: "currencyControlPressed:", forControlEvents:.ValueChanged)
        defaultCurrencyControl.addTarget(self, action: "currencyControlPressed:", forControlEvents:.TouchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    func currencyControlPressed(sender: UISegmentedControl){
        appDelegate.userDefaults.setObject(sender.selectedSegmentIndex, forKey: "defaultCurrency")
        appDelegate.userDefaults.synchronize()
        appDelegate.updateDefaultCurrency()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
