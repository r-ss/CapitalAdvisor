//
//  StockEditViewController.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

import EasyAnimation

class StockEditViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    // MARK: Properties
    
    let labelName = UILabel()
    let textFieldName = UITextField()
    
    let labelValue = UILabel()
    let textFieldValue = UITextField()
    
    let labelPercent = UILabel()
    let textFieldPercent = UITextField()
    
    let segmentedControlCurrency = UISegmentedControl(items: [Currency.RUB.pluralTitle, Currency.USD.pluralTitle, Currency.EUR.pluralTitle])
    
    let labelDepositDate = UILabel()
    let textFieldDepositDate = UITextField()
    let depositDatePickerView = UIDatePicker()
    var depositDatePicked: NSDate?
    //let depositNotifyLabel = UILabel()
    //let depositNotifySwitch = UISwitch()
    
    let labelNote = UILabel()
    let textViewNote = UITextView()
    
    var scrollView: UIScrollView!


    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!

    
    var stock: Stock?
    var selectedType:Type = .Cash
    
    //var validationTimer = NSTimer()
    
    var activeField: UITextField? // for scrolling in case of keyboard overlapping
    
    var editMode:Bool = false // Are we editing or adding new Stock
    var nameTextFieldWasTouchedByUser:Bool = false
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    struct Data {
        var name:String = ""
        var value:Double = 0.0
        var currency:Currency = .RUB
        var percent:Double = 0.0
        var note:String = ""
    }
    var data = Data()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        cancelButton.target = self
        cancelButton.action = "cancelPressed"
        saveButton.target = self
        saveButton.action = "savePressed"
        saveButton.enabled = false
        
        //print("> StockEditViewController > SELECTED TYPE: \(self.selectedType)")
        generateInputViews()
        

        // Set up views if editing an existing Stock.
        if let stock = stock {
            navigationItem.title = stock.type.title
            textFieldName.text = stock.name
            textFieldValue.text = stock.value.convertedToString!
            textFieldPercent.text = "\((stock.percent * 100).convertedToString!)"
            textViewNote.text = stock.note
            
            if let _:NSDate = stock.depositDueDate {
                applyDate(stock.depositDueDate!)
            }
            
            
            //textFieldValue.text = textFieldValue.text!.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
            //textFieldPercent.text = textFieldPercent.text!.stringByReplacingOccurrencesOfString(".", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            //textFieldValue.text = formatter.stringFromNumber(stock.value)
            //textFieldPercent.text = formatter.stringFromNumber(stock.percent * 100)
            segmentedControlCurrency.selectedSegmentIndex = stock.currency.id
            editMode = true
        } else {
            print(selectedType)
            textFieldName.text = selectedType.title
            segmentedControlCurrency.selectedSegmentIndex = defaultCurrency.id
            navigationItem.title = selectedType.title
        }
        
        //registerForKeyboardNotifications()
        //addDoneButtonToKeyboard()
        validateInputFields(false)
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
        
    }
    
    override func viewWillDisappear(animated: Bool) {

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
        
        
        
        let navCont = parentViewController! as! UINavigationController
        let navBarHeight = navCont.navigationBar.frame.size.height
        print("Navigation Bar Height = \(navBarHeight)")
        
        var topMarginSummary:CGFloat = navBarHeight + 20
        
        topMarginSummary = 20
        
        
        self.scrollView = UIScrollView()
        //self.scrollView.frame = self.view.bounds
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.scrollView.delegate = self
        self.scrollView.contentSize = viewSize
        self.view.addSubview(self.scrollView)
        
        
        func addLabel(label:UILabel, text:String, frame:CGRect){
            label.frame = frame
            styleLabel(label)
            label.text = text
            self.scrollView.addSubview(label)
            topMarginSummary += (labelHeight + smallMargin)
        }
        
        func addTextField(field:UITextField, text:String, frame:CGRect){
            field.frame = frame
            styleTextField(field)
            field.text = text
            field.keyboardType = .Default
            self.scrollView.addSubview(field)
            topMarginSummary += (fieldHeight + bigMargin)
        }
        
        //
        // Name
        //
        addLabel(labelName, text:"Название", frame: CGRect(x: labelMargin, y: topMarginSummary, width: labelWidth, height: labelHeight))
        addTextField(textFieldName, text:"Название", frame: CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth, height: fieldHeight))
        
        //
        // Value
        //
        addLabel(labelValue, text:"Сумма", frame: CGRect(x: labelMargin, y: topMarginSummary, width: labelWidth * 0.5, height: labelHeight))
        addTextField(textFieldValue, text:"0", frame: CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth * 0.65 - fieldMargin, height: fieldHeight))
        textFieldValue.keyboardType = UIKeyboardType.DecimalPad
        
        //
        // Percent
        //
        func addPercent(){
            let labelPercentWidth = labelWidth * 0.5
            let textFieldPercentWidth = longFieldWidth * 0.35
            //topMarginSummary -= (labelHeight + smallMargin)
            topMarginSummary -= (fieldHeight + bigMargin)
            addLabel(labelPercent, text:"Процентная ставка", frame: CGRect(x: screenWidth - labelPercentWidth - labelMargin, y: topMarginSummary - labelHeight - smallMargin, width: labelPercentWidth, height: labelHeight))
            topMarginSummary -= (labelHeight + smallMargin)
            addTextField(textFieldPercent, text:"0", frame: CGRect(x: screenWidth - textFieldPercentWidth - fieldMargin, y: topMarginSummary, width: textFieldPercentWidth, height: fieldHeight))
            labelPercent.textAlignment = .Right
            textFieldPercent.keyboardType = UIKeyboardType.DecimalPad
            textFieldPercent.textAlignment = .Right
            
            let percentSymbol = UILabel()
            percentSymbol.text = "%"
            percentSymbol.textColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0)
            percentSymbol.font = UIFont.systemFontOfSize(22, weight: UIFontWeightLight)
            percentSymbol.sizeToFit()
            percentSymbol.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            textFieldPercent.rightView = percentSymbol
            textFieldPercent.rightViewMode = UITextFieldViewMode.Always
        }
        
        //
        // Currency
        //
        func addCurrency(){
            topMarginSummary += smallMargin
            segmentedControlCurrency.frame = CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth, height: fieldHeight * 0.75)
            segmentedControlCurrency.selectedSegmentIndex = 0
            self.scrollView.addSubview(segmentedControlCurrency)
            topMarginSummary += fieldHeight + bigMargin
        }
        
        //
        // Deposit date
        //
        func addDepositDate(){
            addLabel(labelDepositDate, text:"Окончание депозита", frame: CGRect(x: labelMargin, y: topMarginSummary, width: labelWidth, height: labelHeight))
            addTextField(textFieldDepositDate, text:"", frame: CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth, height: fieldHeight))
            depositDatePickerView.datePickerMode = UIDatePickerMode.Date
            textFieldDepositDate.tintColor = UIColor.clearColor() // to hide blinking cursor caret
            textFieldDepositDate.inputView = depositDatePickerView
            depositDatePickerView.locale = NSLocale(localeIdentifier: "ru_RU")
            if let _:Stock = self.stock {
                if let _:NSDate = self.stock!.depositDueDate {
                    depositDatePickerView.date = self.stock!.depositDueDate!
                }
            }
            depositDatePickerView.minimumDate = NSDate()
            let maxDate:NSDate = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Year, value: 10, toDate: NSDate(), options: NSCalendarOptions.WrapComponents)!
            depositDatePickerView.maximumDate = maxDate
            depositDatePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        }
        
        
        //
        // Note
        //
        func addNote(){
            addLabel(labelNote, text:"Заметки", frame: CGRect(x: labelMargin, y: topMarginSummary, width: labelWidth, height: labelHeight))
            textViewNote.frame = CGRect(x: fieldMargin, y: topMarginSummary, width: longFieldWidth, height: fieldHeight * 2)
            styleTextView(textViewNote)
            textViewNote.text = ""
            textViewNote.keyboardType = UIKeyboardType.Default
            self.scrollView.addSubview(textViewNote)
            topMarginSummary += fieldHeight + bigMargin
        }
        
        
        switch self.selectedType {
        case .Deposit, .Debit, .Credit, .Asset:
            addPercent()
        default:
            textFieldPercent.text = "0" // OH...
            textFieldValue.frame.size.width = longFieldWidth
        }
        
        addCurrency()
        
        
        switch self.selectedType {
        case .Deposit:
            addDepositDate()
        default: break
        }
        
        addNote()
        

        textFieldName.delegate = self
        textFieldValue.delegate = self
        textFieldPercent.delegate = self
        
        textFieldName.addTarget(self, action: Selector("validationEventTick:"), forControlEvents: UIControlEvents.EditingChanged)
        textFieldValue.addTarget(self, action: Selector("validationEventTick:"), forControlEvents: UIControlEvents.EditingChanged)
        textFieldPercent.addTarget(self, action: Selector("validationEventTick:"), forControlEvents: UIControlEvents.EditingChanged)
        
        segmentedControlCurrency.addTarget(self, action: Selector("validationEventTick:"), forControlEvents: UIControlEvents.ValueChanged)

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
    
    func handleDatePicker(sender: UIDatePicker) {
        //self.depositDatePicked = sender.date
        applyDate(sender.date)
    }
    
    func applyDate(date:NSDate){
        self.depositDatePicked = date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .LongStyle
        dateFormatter.locale = NSLocale(localeIdentifier: "ru_RU")
        textFieldDepositDate.text = dateFormatter.stringFromDate(date)
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string.characters.count == 0 {
            return true
        }
        
        switch textField {
        case textFieldValue, textFieldPercent:
            let inverseSet = NSCharacterSet(charactersInString:"-.,0123456789.,..,,").invertedSet
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
        
        data.note = textViewNote.text
        
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
    
    //override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
    //}
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(sender: UITextField) {

        if sender === textFieldName {
            if !nameTextFieldWasTouchedByUser {
                textFieldName.becomeFirstResponder()
                textFieldName.selectedTextRange = textFieldName.textRangeFromPosition(textFieldName.beginningOfDocument, toPosition: textFieldName.endOfDocument)
            }
            nameTextFieldWasTouchedByUser = true
        }
        
        if sender === textFieldValue {
            textFieldValue.selectedTextRange = textFieldValue.textRangeFromPosition(textFieldValue.beginningOfDocument, toPosition: textFieldValue.endOfDocument)
        }
        
        if sender === textFieldPercent {
            textFieldPercent.selectedTextRange = textFieldPercent.textRangeFromPosition(textFieldPercent.beginningOfDocument, toPosition: textFieldPercent.endOfDocument)
        }

        activeField = sender
    }
    
    func textFieldDidEndEditing(sender: UITextField) {
        //if sender === textFieldName {
        //    navigationItem.title = sender.text
        //}
    }
    
    
    
    func shakeTextField(field:UITextField){
        
        // https://github.com/icanzilb/EasyAnimation
        
        let time:Double = 0.1
        let delta:CGFloat = 8
        
        UIView.animateAndChainWithDuration(time, delay: 0.0,
            options: .CurveEaseInOut, animations: {
                field.center.x += delta
            }, completion: nil).animateWithDuration(time, animations: {
                field.center.x -= delta
            }).animateWithDuration(time, animations: {
                field.center.x += delta
            }).animateWithDuration(time, animations: {
                field.center.x -= delta
            })
        
    }
    
    func validationEventTick(sender:UITextField){
        validateInputFields()
    }
    
    func validateInputFields(animation:Bool = true) {
        //print("> validateInputFields")
        var valid = false
        
        var validName = false
        var validValue = false
        var validPercent = false
        
        //let formatter = NSNumberFormatter()
        let whitespaceSet = NSCharacterSet.whitespaceCharacterSet()

        let name = textFieldName.text ?? ""
        if name.stringByTrimmingCharactersInSet(whitespaceSet) != "" {
            validName = true
        }
        
        let maybeValue = textFieldValue.text!.convertedToDouble
        if let value = maybeValue {
            if value > 0.0 {
                validValue = true
            }
        }
        
        let maybePercent = textFieldPercent.text!.convertedToDouble
        if let percent = maybePercent {
            if percent >= 0.0 {
                validPercent = true
            }
        }
        
        if !validName && animation {
            shakeTextField(textFieldName)
        }
        if !validValue && animation {
            shakeTextField(textFieldValue)
        }
        if !validPercent && animation {
            shakeTextField(textFieldPercent)
        }
        
        if (validName && validValue && validPercent) { valid = true }
        if valid {
            data.name = name
            data.value = maybeValue!
            data.percent = maybePercent! / 100
            data.currency = Currency(id: segmentedControlCurrency.selectedSegmentIndex)
            data.note = textViewNote.text
        }
        saveButton.enabled = valid
    }
    
    
    // MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if cancelButton === sender {
            print("> StockEditViewController > prepareForSegue > CANCEL PRESSED")
        }
        if saveButton === sender {
            print("> StockEditViewController > prepareForSegue > SAVE PRESSED")
            stock = Stock(type: self.selectedType, name: data.name , value: data.value, currency: data.currency, percent: data.percent, note: data.note)
            //print (stock?.depositDueDate)
            if let date = self.depositDatePicked {
                stock!.depositDueDate = date
            }
            //print (stock?.depositDueDate)
       }
    }

}

