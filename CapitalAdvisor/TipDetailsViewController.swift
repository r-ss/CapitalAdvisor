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
        self.view.backgroundColor = Palette.White.color

        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        //self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        self.scrollView.backgroundColor = Palette.White.color
        self.scrollView.contentInset = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        generateViews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.scrollView.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
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
        label.highlightedText = "\(tip!.intro)\n\n\(tip!.text!)"
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
