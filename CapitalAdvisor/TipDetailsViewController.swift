//
//  TipDetailsViewController.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 07/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class TipDetailsViewController: UIViewController {
    
    var tip:Tip?
    
    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = Palette.White.color

        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.scrollView.backgroundColor = Palette.White.color
        self.view = self.scrollView
    }
    
    override func viewWillAppear(animated: Bool) {
        generateViews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.scrollView.subviews.forEach({
            // Preventint removing scroll indicators from UIScrollView
            if !$0.isKindOfClass(UIImageView){
                $0.removeFromSuperview()
            }
            
        })
        //self.scrollView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        //view.subviews.map({ $0.removeFromSuperview() }) // this returns modified array
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func generateViews(){
        
        let top:CGFloat = 10
        let margin:CGFloat = 16
        let textMargin:CGFloat = 15
        let screenWidth = self.view.frame.size.width
        let cellWidth = screenWidth - margin * 2
        
        
        let label = UILabel.init(frame: CGRect(x: textMargin, y: top + textMargin, width: cellWidth, height: 100))
        label.numberOfLines = 0
        //label.text = tip!.text
        label.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        
        
        let nbsp = tip!.intro.stringByReplacingOccurrencesOfString("_", withString:"\u{00a0}")
        
        
        label.highlightedText = "\(nbsp)\n\n\(tip!.text!)"
        label.sizeToFit()
        //cell.frame.size.height = label.frame.size.height + textMargin * 2
        self.scrollView.addSubview(label)
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, label.frame.height + 100)
        
        
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
