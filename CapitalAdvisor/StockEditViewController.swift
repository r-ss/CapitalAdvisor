//
//  StockEditViewController.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit


class StockEditViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
    @IBOutlet weak var percentTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    
    /*
    This value is either passed by `StockTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new stock.
    */
    var stock: Stock?
    
    var selectedType:Int = 0
    
    var editMode:Bool = false // Are we editing or adding new Stock
    var nameTextFieldWasTouchedByUser:Bool = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        nameTextField.delegate = self
        valueTextField.delegate = self
        percentTextField.delegate = self
        
        
        cancelButton.target = self
        cancelButton.action = "cancelPressed"
        saveButton.target = self
        saveButton.action = "savePressed"
        
        print("> StockEditViewController > SELECTED TYPE: \(self.selectedType)")

        let percentLabel = UILabel()
        percentLabel.text = "%"
        percentLabel.textColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1.0)
        percentLabel.font = UIFont.systemFontOfSize(36, weight: UIFontWeightLight)
        percentLabel.sizeToFit()
        percentTextField.rightView = percentLabel
        percentTextField.rightViewMode = UITextFieldViewMode.Always
        
        
        // Set up views if editing an existing Stock.
        if let stock = stock {
            navigationItem.title = stock.type_name
            nameTextField.text = stock.name
            valueTextField.text = "\(stock.value)"
            percentTextField.text = "\(stock.percent * 100)"
            currencySegmentedControl.selectedSegmentIndex = appDelegate.currencyToInt(stock.currency)
            
            //stockTypePicker.selectRow(stock.type, inComponent: 0, animated: false)
            editMode = true
        } else {
            nameTextField.text = appDelegate.container.stocksTypesArray[selectedType]
            currencySegmentedControl.selectedSegmentIndex = appDelegate.currencyToInt(defaultCurrency)
            navigationItem.title = appDelegate.container.stocksTypesArray[selectedType]
        }
        
        addDoneButtonToKeyboard()
        
        checkValidData()
    }
    
    func cancelPressed() {
        print("> StockEditViewController > cancelPressed")
        
        if editMode {
            self.performSegueWithIdentifier("unwindToStockDetails", sender: self.cancelButton)
        } else {
            self.performSegueWithIdentifier("unwindToStockList", sender: self.cancelButton)
        }
    }
    
    func savePressed() {
        print("> StockEditViewController > savePressed")
        if editMode {
            self.performSegueWithIdentifier("unwindToStockDetails", sender: self.saveButton)
        } else {
            self.performSegueWithIdentifier("unwindToStockList", sender: self.saveButton)
        }

    }
    
    func addDoneButtonToKeyboard() {
        let doneButton:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "hideKeyboard")
        let space:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        var items = [UIBarButtonItem]()
        items.append(space)
        items.append(doneButton)
        let toolbar:UIToolbar = UIToolbar ()
        toolbar.items = items
        toolbar.sizeToFit()
        valueTextField.inputAccessoryView = toolbar
        percentTextField.inputAccessoryView = toolbar
    }
    
    func hideKeyboard() {
        valueTextField.resignFirstResponder()
        percentTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(sender: UITextField) {
        // Disable the Save button while editing.
        if sender === nameTextField {
            if !nameTextFieldWasTouchedByUser {
                nameTextField.becomeFirstResponder()
                nameTextField.selectedTextRange = nameTextField.textRangeFromPosition(nameTextField.beginningOfDocument, toPosition: nameTextField.endOfDocument)
            }
            nameTextFieldWasTouchedByUser = true
        }
    }
    
    func checkValidData() {
        // Disable the Save button if the text field is empty.
        let name = nameTextField.text ?? ""
        saveButton.enabled = !name.isEmpty
        
        let value = valueTextField.text ?? ""
        saveButton.enabled = !value.isEmpty
    }
    
    func textFieldDidEndEditing(sender: UITextField) {
        checkValidData()
        
        if sender === nameTextField {
            navigationItem.title = sender.text
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {     
        
        if cancelButton === sender {
            print("> StockEditViewController > prepareForSegue > CANCEL PRESSED")
        }
        
        if saveButton === sender {
            print("> StockEditViewController > prepareForSegue > SAVE PRESSED")
            let name = nameTextField.text ?? ""
            
            //selectedType = .Cash
            //let type:Int = self.selectedType
            
            let value = valueTextField.text ?? "0"
            let percent = percentTextField.text ?? "0"
            let currency = appDelegate.intToCurrency(currencySegmentedControl.selectedSegmentIndex);
            
            let percentCleaned = percent.stringByReplacingOccurrencesOfString(",", withString: ".", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            var percentNatural: Double = 0.0
            if percent != "" {
                percentNatural = Double(percentCleaned)! / 100
            }
            
            // Set the meal to be passed to MealTableViewController after the unwind segue.
            if value != "" {
                stock = Stock(type: self.selectedType, name: name , value: Double(value)!, currency: currency, percent: percentNatural)
            }
       }
    }

}

