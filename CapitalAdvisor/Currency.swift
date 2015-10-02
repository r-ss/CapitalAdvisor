//
//  Currency.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 02/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import Foundation

enum Currency {
    case RUB, USD, EUR
    init () {
        self = .RUB
    }
    
    init (id:Int) {
        switch id {
        case 0: self = .RUB
        case 1: self = .USD
        case 2: self = .EUR
        default: self = .RUB
        }
    }
    
    var title: String {
        switch self {
        case .RUB: return "Рубль"
        case .USD: return "Доллар"
        case .EUR: return "Евро"
        }
    }
    
    var pluralTitle: String {
        switch self {
        case .RUB: return "Рубли"
        case .USD: return "Доллары"
        case .EUR: return "Евро"
        }
    }
    
    var id: Int {
        switch self {
        case .RUB: return 0
        case .USD: return 1
        case .EUR: return 2
        }
    }
    
}

var defaultCurrency:Currency = .RUB