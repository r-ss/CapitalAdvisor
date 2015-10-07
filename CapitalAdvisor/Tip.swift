
//
//  Tip.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 06/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import Foundation

class Tip {
    
    var intro:String = ""
    var teaser:String = ""
    var text:String?
    
    init(intro:String, teaser:String = "Подробнее", text:String? = nil){
        self.intro = intro
        self.teaser = teaser
        self.text = text
    }
}