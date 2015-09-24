//
//  StockTableViewCell.swift
//  Capital
//
//  Created by Alex Antipov on 13/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!

    @IBOutlet weak var colorRectangleView: UIView!
    
    // These two methods for preventing transparent cell background while rearrange cells in table view.
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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
