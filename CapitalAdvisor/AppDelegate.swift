//
//  AppDelegate.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let exchangeRates:ExchangeRates = ExchangeRates()!
    let container:StocksContainer = StocksContainer()
    let valueFormat:ValueFormat = ValueFormat()!
    var defaultCurrency:Int = 0

    var window: UIWindow?
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //var stocksTableViewControler:UITableViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //exchangeRates.load()

        
        if let defaultCurrency = userDefaults.objectForKey("defaultCurrency") as? Int {
            self.defaultCurrency = defaultCurrency
        } else {
            userDefaults.setObject(0, forKey: "defaultCurrency")
            userDefaults.synchronize()
        }
        
        if let latestStartTime = userDefaults.objectForKey("LatestStartTime") as? NSDate {
            print("Latest Start Time: \(latestStartTime)")
        } else {
            print("First Start")
            firstStartRoutine()
        }
        
        userDefaults.setObject(NSDate(), forKey: "LatestStartTime")
        userDefaults.synchronize()
        
        container.loadStocks()
        return true
    }
    
    func firstStartRoutine() {
        
        
    }
    
    func updateDefaultCurrency(){
        if let defaultCurrency = userDefaults.objectForKey("defaultCurrency") as? Int {
            self.defaultCurrency = defaultCurrency
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        print("AppDelegate > applicationWillResignActive")
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("AppDelegate > applicationDidEnterBackground")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        print("AppDelegate > applicationWillEnterForeground")
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        print("AppDelegate > applicationDidBecomeActive")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        print("AppDelegate > applicationWillTerminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

