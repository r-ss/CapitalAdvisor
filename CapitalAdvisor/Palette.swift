//
//  Palette.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 06/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import UIKit

enum Palette {
    case Black, Accent, Dark, Medium, Light, Lightest, White
    
    var color: UIColor {
        switch self {
        case .Black: return UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0)
        case .Accent: return UIColor(red: 146/255, green: 214/255, blue: 239/255, alpha: 1.0)
        case .Dark: return UIColor(red: 80/255, green: 67/255, blue: 38/255, alpha: 1.0)
        case .Medium: return UIColor(red: 151/255, green: 139/255, blue: 114/255, alpha: 1.0)
        case .Light: return UIColor(red: 216/255, green: 206/255, blue: 181/255, alpha: 1.0)
        case .Lightest: return UIColor(red: 232/255, green: 228/255, blue: 202/255, alpha: 1.0)
        case .White: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        }
    }
}