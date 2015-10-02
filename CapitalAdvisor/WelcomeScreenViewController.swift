//
//  WelcomeScreenViewController.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 02/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class WelcomeScreenViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func cuntinueButtonAction(sender: UIButton) {
        
        
        print("cuntinueButtonAction")
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UITabBarController = storyboard.instantiateViewControllerWithIdentifier("ID_CapitalViewController") as! UITabBarController
        appDelegate.window!.rootViewController = vc
        
        
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
