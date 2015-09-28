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
    
    let labelName = UILabel()
    let textFieldName = UITextField()
    
    let labelValue = UILabel()
    let textFieldValue = UITextField()
    
    let labelPercent = UILabel()
    let textFieldPercent = UITextField()
    
    let segmentedControlCurrency = UISegmentedControl(items: ["Рубли", "Доллары", "Евро"])
    
    let labelNote = UILabel()
    let textViewNote = UITextView()

    
    
//    @IBOutlet weak var nameTextField: UITextField!
//    @IBOutlet weak var valueTextField: UITextField!
//    @IBOutlet weak var currencySegmentedControl: UISegmentedControl!
//    
//    
//    @IBOutlet weak var percentLabel: UILabel!
//    @IBOutlet weak var percentTextField: UITextField!
//    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
//    
//    @IBOutlet weak var scrollView: UIScrollView!
//    
//    @IBOutlet weak var notesTextView: UITextView!
    
    
    /*
    @IBOutlet weak var scrollView: UIScrollView!
    This value is either passed by `StockTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new stock.
    */
    var stock: Stock?
    
    var selectedType:Type = .Cash
    
    var validationTimer = NSTimer()
    
    var activeField: UITextField? // for scrolling in case of keyboard overlapping
    
    
    var editMode:Bool = false // Are we editing or adding new Stock
    var nameTextFieldWasTouchedByUser:Bool = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        notesTextView.layer.backgroundColor = UIColor.whiteColor().CGColor
//        notesTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).CGColor
//        notesTextView.layer.borderWidth = 1.0
//        notesTextView.layer.cornerRadius = 5
//        
//        
//        
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        cancelButton.target = self
        cancelButton.action = "cancelPressed"
        saveButton.target = self
        saveButton.action = "savePressed"
        
        print("> StockEditViewController > SELECTED TYPE: \(self.selectedType)")

        
        
        // Set up views if editing an existing Stock.
        if let stock = stock {
            navigationItem.title = stock.type_name
            textFieldName.text = stock.name
            textFieldValue.text = "\(stock.value)"
            textFieldPercent.text = "\(stock.percent * 100)"
            segmentedControlCurrency.selectedSegmentIndex = currencyToInt(stock.currency)
            
            //stockTypePicker.selectRow(stock.type, inComponent: 0, animated: false)
            editMode = true
        } else {
            textFieldName.text = typeToName(selectedType)
            segmentedControlCurrency.selectedSegmentIndex = currencyToInt(defaultCurrency)
            navigationItem.title = typeToName(selectedType)
        }
        
        
        //registerForKeyboardNotifications()
        
        //addDoneButtonToKeyboard()
        
        generateInputViews()
        
       // checkValidData()
    }
    
    override func viewWillAppear(animated: Bool) {
        //print("viewWillAppear")
        self.textFieldName.becomeFirstResponder()
        
        /*
        switch self.selectedType {
        case .Cash, .Bank:
            self.labelPercent.hidden = true
            self.textFieldPercent.hidden = true
        default:
            self.labelPercent.hidden = false
            self.textFieldPercent.hidden = false
        }
        */
        
       // self.scrollView.
        
        //self.scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        
        validationTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "validateInputFields", userInfo: nil, repeats: true)
        
        

    }
    
    override func viewWillDisappear(animated: Bool) {
  
        validationTimer.invalidate()
        
        
    }
    
    
    
    
    func generateInputViews(){
        
        let viewSize = self.view.frame.size
        let screenWidth = viewSize.width
        
        let labelMargin:CGFloat = 20.0
        let fieldMargin:CGFloat = 13.0
        let smallMargin:CGFloat = 2.0
        let bigMargin:CGFloat = smallMargin * 2
        let fieldHeight:CGFloat = 40.0
        let labelHeight:CGFloat = 18.0
        
        let longFieldWidth = screenWidth - fieldMargin * 2
        let labelWidth = screenWidth - labelMargin * 2
        
        var topMarginSummary:CGFloat = 20
        
        //
        // Name
        //
        labelName.frame = CGRect(x: labelMargin, y: topMarginSummary, width: labelWidth, height: labelHeight)
        styleLabel(labelName)
        labelName.text = "Название"
        self.view.addSubview(labelName)
        topMarginSummary += labelHeight + smallMargin
        
        textFieldName.frame = CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth, height: fieldHeight)
        styleTextField(textFieldName)
        textFieldName.text = "Название"
        textFieldName.keyboardType = UIKeyboardType.ASCIICapable
        self.view.addSubview(textFieldName)
        topMarginSummary += fieldHeight + bigMargin
        
        //
        // Value
        //
        labelValue.frame = CGRect(x: labelMargin, y: topMarginSummary, width: labelWidth * 0.5, height: labelHeight)
        styleLabel(labelValue)
        labelValue.text = "Сумма"
        self.view.addSubview(labelValue)
        topMarginSummary += labelHeight + smallMargin
        
        textFieldValue.frame = CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth * 0.65 - fieldMargin, height: fieldHeight)
        styleTextField(textFieldValue)
        textFieldValue.text = "0"
        textFieldValue.keyboardType = UIKeyboardType.DecimalPad
        self.view.addSubview(textFieldValue)
        //topMarginSummary += fieldHeight + bigMargin
        
        //
        // Percent
        //
        let labelPercentWidth = labelWidth * 0.5
        labelPercent.frame = CGRect(x: screenWidth - labelPercentWidth - labelMargin, y: topMarginSummary - labelHeight - smallMargin, width: labelPercentWidth, height: labelHeight)
        styleLabel(labelPercent)
        labelPercent.text = "Процентная ставка"
        labelPercent.textAlignment = .Right
        //labelPercent.backgroundColor = UIColor.yellowColor()
        self.view.addSubview(labelPercent)
        //topMarginSummary += labelHeight + smallMargin
        
        let textFieldPercentWidth = longFieldWidth * 0.35
        textFieldPercent.frame = CGRect(x: screenWidth - textFieldPercentWidth - fieldMargin, y: topMarginSummary, width: textFieldPercentWidth, height: fieldHeight)
        styleTextField(textFieldPercent)
        textFieldPercent.text = "0"
        textFieldPercent.keyboardType = UIKeyboardType.DecimalPad
        textFieldPercent.textAlignment = .Right
        self.view.addSubview(textFieldPercent)
        
        let percentSymbol = UILabel()
        percentSymbol.text = "%"
        percentSymbol.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
        percentSymbol.font = UIFont.systemFontOfSize(22, weight: UIFontWeightLight)
        percentSymbol.sizeToFit()
        // (0.0, 0.0, 16.5, 26.5)
        print(percentSymbol.frame)
        percentSymbol.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //percentSymbol.backgroundColor = UIColor.yellowColor()
        textFieldPercent.rightView = percentSymbol
        textFieldPercent.rightViewMode = UITextFieldViewMode.Always
        
        topMarginSummary += fieldHeight + bigMargin
        
        //
        // Currency
        //
        /*
        let labelCurrency: UILabel = UILabel(frame: CGRect(x: labelMargin, y: topMarginSummary, width: labelWidth, height: labelHeight))
        styleLabel(labelCurrency)
        labelCurrency.text = "Валюта"
        self.view.addSubview(labelCurrency)
        topMarginSummary += labelHeight + smallMargin
        */
        
        topMarginSummary += smallMargin
        
        segmentedControlCurrency.frame = CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth, height: fieldHeight * 0.75)
        segmentedControlCurrency.selectedSegmentIndex = 0
        
        self.view.addSubview(segmentedControlCurrency)
        topMarginSummary += fieldHeight + bigMargin
        
        
        //
        // Note
        //
        labelNote.frame = CGRect(x: labelMargin, y: topMarginSummary, width: labelWidth, height: labelHeight)
        styleLabel(labelNote)
        labelNote.text = "Заметки"
        self.view.addSubview(labelNote)
        topMarginSummary += labelHeight + smallMargin
        
        textViewNote.frame = CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth, height: fieldHeight * 2)
        styleTextView(textViewNote)
        textViewNote.text = ""
        textViewNote.keyboardType = UIKeyboardType.ASCIICapable
        self.view.addSubview(textViewNote)
        topMarginSummary += fieldHeight + bigMargin
        
        
        
        textFieldName.delegate = self
        textFieldValue.delegate = self
        textFieldPercent.delegate = self
        
        
        
        //        let textFieldPercent: UITextField = UITextField(frame: CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth, height: fieldHeight))
        //        styleTextField(textFieldPercent)
        //        textFieldPercent.text = "12%"
        //        self.view.addSubview(textFieldPercent)
        //        topMarginSummary += fieldHeight + bigMargin
        
    }
    
    func styleLabel(label:UILabel) {
        label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
        label.textColor = UIColor(red: 125/255, green: 125/255, blue: 125/255, alpha: 1.0)
        styleView(label)
    }
    
    func styleTextField(field:UITextField) {
        field.borderStyle = UITextBorderStyle.RoundedRect
        field.font = UIFont.systemFontOfSize(22, weight: UIFontWeightLight)
        styleView(field)
    }
    
    func styleTextView(view:UITextView) {
        view.layer.backgroundColor = UIColor.whiteColor().CGColor
        view.layer.borderColor = UIColor(red: 0.82, green: 0.82, blue: 0.82, alpha: 1.0).CGColor
        view.layer.borderWidth = 0.65
        view.layer.cornerRadius = 5
        view.font = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
        styleView(view)
    }
    
    func styleView(view:UIView){
        view.backgroundColor = UIColor.whiteColor()
    }
    
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // We ignore any change that doesn't add characters to the text field.
        // These changes are things like character deletions and cuts, as well
        // as moving the insertion point.
        //
        // We still return true to allow the change to take place.
        
        if string.characters.count == 0 {
            return true
        }
        
        // Check to see if the text field's contents still fit the constraints
        // with the new content added to it.
        // If the contents still fit the constraints, allow the change
        // by returning true; otherwise disallow the change by returning false.
        //let currentText = textField.text ?? ""
        //let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch textField {
        case textFieldValue, textFieldPercent:
            let inverseSet = NSCharacterSet(charactersInString:"-.0123456789").invertedSet
            let components = string.componentsSeparatedByCharactersInSet(inverseSet)
            let filtered = components.joinWithSeparator("")  // use join("", components) if you are using Swift 1.2
            return string == filtered
        default:
            return true
        }
        
        
        
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
    
    /*
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
    */
    
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
    /*
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
*/
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(sender: UITextField) {
        // Disable the Save button while editing.
        
        if sender === textFieldName {
            if !nameTextFieldWasTouchedByUser {
                textFieldName.becomeFirstResponder()
                textFieldName.selectedTextRange = textFieldName.textRangeFromPosition(textFieldName.beginningOfDocument, toPosition: textFieldName.endOfDocument)
            }
            nameTextFieldWasTouchedByUser = true
        }

        activeField = sender
    }
    
    func textFieldDidEndEditing(sender: UITextField) {
        
        if sender === textFieldName {
            navigationItem.title = sender.text
        }
        
        //activeField = nil
    }
    
    func validateInputFields() {
        //print("> validateInputFields")
        var valid = false
        
        
        // Disable the Save button if the text field is empty.
        let name = textFieldName.text ?? ""
        let nameIsValid = !name.isEmpty
        
        var valueIsValid = false
        if let value = Double(textFieldValue.text!) {
            if value > 0 {
                valueIsValid = true
            }
        }
        
        var percentIsValid = false
        let percent = textFieldPercent.text ?? ""
        if !percent.isEmpty {
            if let value = Double(textFieldPercent.text!) {
                if value >= 0 {
                    percentIsValid = true
                }
            }
        } else {
            percentIsValid = true
        }
        
        if (nameIsValid && valueIsValid && percentIsValid) {
            valid = true
        }
        
        saveButton.enabled = valid
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
            let name = textFieldName.text ?? ""
            
            let value = textFieldValue.text ?? "0"
            let percent = textFieldPercent.text ?? "0"
            let currency = intToCurrency(segmentedControlCurrency.selectedSegmentIndex);
            
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

