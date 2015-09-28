//
//  AddStockTableViewController.swift
//  Capital
//
//  Created by Alex Antipov on 21/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class AddStockTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(self.tableView.frame.height)

        self.tableView.rowHeight = (self.tableView.frame.height - 112) / CGFloat(appDelegate.container.numberOfStocksTypes)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.container.numberOfStocksTypes
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cellIdentifier = "AddStockTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier("AddStockTableViewCell", forIndexPath: indexPath) as! AddStockTableViewCell
        
        //let stockTypeName = appDelegate.container.stocksTypesArray[indexPath.row]
        
        let stockTypeName = typeNamesArray[indexPath.row]
        
        
        cell.nameLabel.textColor = UIColor.whiteColor()
        cell.nameLabel.text = stockTypeName
        
        let colorTools:ColorTools = ColorTools()
        cell.backgroundColor = colorTools.stepGradientColorForIndex(indexPath.row, total: appDelegate.container.numberOfStocksTypes)

        return cell
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItemWithType" {
            let stockEditViewController = segue.destinationViewController as! StockEditViewController
            // Get the cell that generated this segue.
            if let selectedTypeCell = sender as? AddStockTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedTypeCell)!
                //print(indexPath.row)
                //let selectedStockType = indexPath.row
                stockEditViewController.selectedType = intToType(indexPath.row)
            }
        }
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

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
