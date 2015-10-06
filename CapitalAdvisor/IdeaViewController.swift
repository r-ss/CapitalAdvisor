//
//  IdeaViewController.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 06/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class IdeaViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        
        self.generateCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func generateCells() {
        
        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        
        var top:CGFloat = 100
        let margin:CGFloat = 20
        let screenWidth = self.view.frame.size.width
        let cellWidth = screenWidth - margin * 2
        
        
        for index in 1...5 {
            
            let height:CGFloat = 150
            
            let cell = UIView.init(frame: CGRect(x: margin, y: top, width: cellWidth, height: height))
            cell.backgroundColor = UIColor.yellowColor()
            self.scrollView.addSubview(cell)
            
            
            
            let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: cellWidth, height: height))
            //let textview = UITextView.init(frame: CGRect(x: 0, y: 0, width: 150, height: height))
            label.numberOfLines = 0
            label.text = "\(index) Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            label.sizeToFit()
            
            cell.frame.size.height = label.frame.size.height
            cell.addSubview(label)
            
            top += cell.frame.size.height + margin
            
            
            
            
        }
        
        top += 70
        
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, top)
        
        
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
