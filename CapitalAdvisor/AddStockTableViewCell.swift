//
//  AddStockTableViewCell.swift
//  Capital
//
//  Created by Alex Antipov on 21/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class AddStockTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override var alpha: CGFloat {
        didSet {
            super.alpha = 1
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.backgroundView = UIView()
        self.backgroundView!.backgroundColor = UIColor.whiteColor()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
