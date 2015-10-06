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
    //@IBOutlet weak var touchIDSwitch: UISwitch!
    
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultCurrencyControl.selectedSegmentIndex = defaultCurrency.id
        
        /*
        if let useTouchID = appDelegate.userDefaults.objectForKey("useTouchID") as? Bool {
            touchIDSwitch.on = useTouchID
        } else {
            touchIDSwitch.on = false
        }
        */
        
        defaultCurrencyControl.addTarget(self, action: "currencyControlPressed:", forControlEvents:.ValueChanged)
        defaultCurrencyControl.addTarget(self, action: "currencyControlPressed:", forControlEvents:.TouchUpInside)
        
       //touchIDSwitch.addTarget(self, action: "touchIDSwitchPressed:", forControlEvents:.TouchUpInside)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func currencyControlPressed(sender: UISegmentedControl){
        appDelegate.userDefaults.setObject(sender.selectedSegmentIndex, forKey: "defaultCurrency")
        appDelegate.userDefaults.synchronize()
        
        defaultCurrency = Currency(id: sender.selectedSegmentIndex)
        
        //appDelegate.updateDefaultCurrency()
    }
    
    func touchIDSwitchPressed(sender: UISwitch){
        print(sender.on)
        let useTouchID:Bool = sender.on
        appDelegate.userDefaults.setObject(useTouchID, forKey: "useTouchID")
        appDelegate.userDefaults.synchronize()
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
