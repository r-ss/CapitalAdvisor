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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    
    /*
    @IBOutlet weak var scrollView: UIScrollView!
    This value is either passed by `StockTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new stock.
    */
    var stock: Stock?
    
    var selectedType:Type = .Cash
    
    var activeField: UITextField? // for scrolling in case of keyboard overlapping
    
    
    var editMode:Bool = false // Are we editing or adding new Stock
    var nameTextFieldWasTouchedByUser:Bool = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        notesTextView.layer.backgroundColor = UIColor.whiteColor().CGColor
        notesTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
        notesTextView.layer.borderWidth = 1.0
        notesTextView.layer.cornerRadius = 5
        
        
        
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
            currencySegmentedControl.selectedSegmentIndex = currencyToInt(stock.currency)
            
            //stockTypePicker.selectRow(stock.type, inComponent: 0, animated: false)
            editMode = true
        } else {
            nameTextField.text = typeToName(selectedType)
            currencySegmentedControl.selectedSegmentIndex = currencyToInt(defaultCurrency)
            navigationItem.title = typeToName(selectedType)
        }
        
        
        registerForKeyboardNotifications()
             

        //addDoneButtonToKeyboard()
        
        checkValidData()
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("viewWillAppear")
        self.nameTextField.becomeFirstResponder()
        
       // self.scrollView.
        
        //self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)

    }
    
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications() {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification:NSNotification){
        print("keyboardWillShow")
        let info:NSDictionary = notification.userInfo!
        let kbSize:CGSize = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue.size)!
        //print(kbSize)
        let contentInsets:UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect:CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        if (!CGRectContainsPoint(aRect, activeField!.frame.origin) ) {
            let scrollPoint:CGPoint = CGPointMake(0.0, activeField!.frame.origin.y-kbSize.height)
            scrollView.setContentOffset(scrollPoint, animated: false)
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        print("keyboardWillHide")
        let contentInsets:UIEdgeInsets  = UIEdgeInsetsZero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
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
        
        activeField = sender
    }
    
    func textFieldDidEndEditing(sender: UITextField) {
        checkValidData()
        
        if sender === nameTextField {
            navigationItem.title = sender.text
        }
        
        //activeField = nil
    }
    
    func checkValidData() {
        // Disable the Save button if the text field is empty.
        let name = nameTextField.text ?? ""
        saveButton.enabled = !name.isEmpty
        
        let value = valueTextField.text ?? ""
        saveButton.enabled = !value.isEmpty
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
            
            let value = valueTextField.text ?? "0"
            let percent = percentTextField.text ?? "0"
            let currency = intToCurrency(currencySegmentedControl.selectedSegmentIndex);
            
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

