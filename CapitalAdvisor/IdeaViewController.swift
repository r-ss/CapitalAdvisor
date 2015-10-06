//
//  IdeaViewController.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 06/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var tips:Tips!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tips = appDelegate.tips

        self.view.backgroundColor = Palette.White.color
        
        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        self.scrollView.backgroundColor = Palette.White.color
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tips.analyse()
        self.generateCells()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.scrollView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        //view.subviews.map({ $0.removeFromSuperview() }) // this returns modified array
    }
    
    
    func generateCells() {
        
        
        var top:CGFloat = 100
        let margin:CGFloat = 16
        let textMargin:CGFloat = 5
        let screenWidth = self.view.frame.size.width
        let cellWidth = screenWidth - margin * 2

        
        for tip in self.tips.tips {
            
            let height:CGFloat = 150
            
            let cell = UIView.init(frame: CGRect(x: margin, y: top, width: cellWidth, height: height))
            cell.backgroundColor = Palette.White.color
            self.scrollView.addSubview(cell)
            
            let label = UILabel.init(frame: CGRect(x: textMargin, y: textMargin, width: cellWidth - textMargin * 2, height: height))
            //let textview = UITextView.init(frame: CGRect(x: 0, y: 0, width: 150, height: height))
            label.numberOfLines = 0
            //label.text = tip.text
            label.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
            label.highlightedText = tip.text!
            label.sizeToFit()
            cell.frame.size.height = label.frame.size.height + textMargin * 2
            cell.addSubview(label)
            top += cell.frame.size.height + 75
            
            let button = UILabel.init(frame: CGRect(x:textMargin, y:cell.frame.size.height - textMargin, width: cellWidth - textMargin * 2, height: 30))
            button.text = "Подробнее"
            button.textAlignment = .Right
            button.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
            //button.backgroundColor = Palette.W.color
            button.textColor = Palette.Dark.color
            cell.addSubview(button)
            
        }
        
        top += 70
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, top)
        
        
    }



}
