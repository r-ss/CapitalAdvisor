//
//  FormViewController.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 25/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

import SwiftForms


//class FormViewController: UIViewController {
    
class SwiftFormViewController: FormViewController {
    
//    private enum Tags : String {
//        case Name = "name"
//        case Value = "value"
//        case Percent = "percent"
//        case Currency = "currency"
//        case Date = "date"
//        case Note = "note"
//    }
    
    struct Static {
        static let nameTag = "name"
        static let valueTag = "value"
        static let currencyTag = "currency"
        static let percentTag = "percent"
        
        static let date = "date"
        static let enabled = "enabled"
        
        static let textView = "textview"
    }
    
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.initializeForm()
//    }
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//        
//    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submit:")
    }
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        let message = self.form.formValues().description
        
        let alert: UIAlertView = UIAlertView(title: "Form output", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
    }
    
//    func disableEnable(button : UIBarButtonItem)
//    {
//        self.form.disabled = !self.form.disabled
//        button.title = self.form.disabled ? "Enable" : "Disable"
//        self.tableView.endEditing(true)
//        self.tableView.reloadData()
//    }
    
    
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "Example Form"
        
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.nameTag, rowType: .Text, title: "Название")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "Название", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.valueTag, rowType: .Text, title: "Сумма")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "0", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.currencyTag, rowType: .SegmentedControl, title: "Валюта")
        row.configuration[FormRowDescriptor.Configuration.Options] = [0, 1, 2]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case 0:
                return "Рубль"
            case 1:
                return "Доллар"
            case 2:
                return "Евро"
            default:
                return nil
            }
            } as TitleFormatterClosure
        
        //row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["titleLabel.font" : UIFont.boldSystemFontOfSize(30.0), "segmentedControl.tintColor" : UIColor.redColor()]
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.percentTag, rowType: .Text, title: "Процентная ставка")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "0", "textField.textAlignment" : NSTextAlignment.Right.rawValue]
        section1.addRow(row)
        

        
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.date, rowType: .Date, title: "Окончание депозита")
        section2.addRow(row)

        row = FormRowDescriptor(tag: Static.enabled, rowType: .BooleanSwitch, title: "Напомнить об окончании")
        section2.addRow(row)
        
        
//        let section3 = FormSectionDescriptor()
//        
//        row = FormRowDescriptor(tag: Static.textView, rowType: .MultilineText, title: "Заметки")
//        section3.headerTitle = "Multiline TextView"
//        section3.addRow(row)
        
        
        
        form.sections = [section1, section2]
        
        self.form = form
    }
    
        /*
    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor
        
        
        

        form = XLFormDescriptor(title: "FORM")
        
        section = XLFormSectionDescriptor.formSection() //
        form.addFormSection(section)
        
        
        row = XLFormRowDescriptor(tag: Tags.Name.rawValue, rowType:XLFormRowDescriptorTypeText, title:"Название")
        row.value = "Сбербанк"
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Value.rawValue, rowType:XLFormRowDescriptorTypeDecimal, title:"Сумма")
        row.value = 500000.0
        
        row.cellConfig.setObject(UIFont.systemFontOfSize(14, weight: UIFontWeightRegular), forKey:"textLabel.font")
        row.cellConfig.setObject(UIFont.systemFontOfSize(24, weight: UIFontWeightLight), forKey:"textField.font")
        //row.cellConfig.setObject(NSTextAlignment.Right, forKey:"textField.textAlignment")
        
        section.addFormRow(row)
        
        
        row = XLFormRowDescriptor(tag: Tags.Percent.rawValue, rowType:XLFormRowDescriptorTypeDecimal, title:"Процентная ставка")
        row.value = 12.5
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Value.rawValue, rowType:XLFormRowDescriptorTypeSelectorAlertView, title:"Валюта")
        
        row.selectorOptions = [
            XLFormOptionsObject(value:0, displayText:"Рубль"),
            XLFormOptionsObject(value:1, displayText:"Доллар"),
            XLFormOptionsObject(value:2, displayText:"Евро"),
        ]
        
        row.value = XLFormOptionsObject(value:0, displayText:"Рубль")
        section.addFormRow(row)
        
        // Date
        row = XLFormRowDescriptor(tag: Tags.Date.rawValue, rowType:XLFormRowDescriptorTypeDate, title:"Дата окончания депозита")
        //row.value = NSDate()
        row.cellConfigAtConfigure["minimumDate"] = NSDate()
        row.cellConfigAtConfigure["maximumDate"] = NSDate(timeIntervalSinceNow: (60*60*24)*365*10 + 5) // max 10 years from now
        section.addFormRow(row)
        
        row = XLFormRowDescriptor(tag: Tags.Note.rawValue, rowType:XLFormRowDescriptorTypeTextView, title:"Заметки")
        //row.value = "Заметки"
        section.addFormRow(row)
        
        
        self.form = form
    }
*/
    
    
    // MARK: - XLFormDescriptorDelegate
    
//    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
//        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)
//    }
    
}

