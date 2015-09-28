//
//  ColorTools.swift
//  Capital
//
//  Created by Alex Antipov on 21/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

class ColorTools {
    
    
    
    // Generates step colors like Clear app
    func stepGradientColorForIndex(index: Int, total: Int) -> UIColor {
        // 11,72,107
        // 207,240,158
        // http://www.colourlovers.com/palette/580974/Adrift_in_Dreams
        
        //print(">>> colorForIndex")
        //print(stocks.count)
        
        let A:[CGFloat] = [11, 72, 107]
        let B:[CGFloat] = [207, 240, 158]
        //let B:[CGFloat] = [78, 205, 196]
        
        if (total > 1){
            let itemCount = total - 1
            let R = (CGFloat(index) / CGFloat(itemCount)) * (B[0] - A[0]) + A[0]
            let G = (CGFloat(index) / CGFloat(itemCount)) * (B[1] - A[1]) + A[1]
            let B = (CGFloat(index) / CGFloat(itemCount)) * (B[2] - A[2]) + A[2]
            return UIColor(red: R/255, green: G/255, blue: B/255, alpha: 1.0)
        } else {
            //print("ZERO")
            return UIColor(red: A[0]/255, green: A[1]/255, blue: A[2]/255, alpha: 1.0)
        }
    }
    
}
