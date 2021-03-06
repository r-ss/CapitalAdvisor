//
//  Type.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 02/10/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

import Foundation

enum Type {
    case Cash, Bank, Deposit, Debit, Credit, Asset, Stock, Income
    init () {
        self = .Cash
    }
    
    init (id:Int) {
        switch id {
        case 0: self = .Cash
        case 1: self = .Bank
        case 2: self = .Deposit
        case 3: self = .Debit
        case 4: self = .Credit
        case 5: self = .Asset
        case 6: self = .Stock
        case 7: self = .Income
        default: self = .Cash
        }
    }
    
    var title: String {
        switch self {
        case .Cash: return "Наличные"
        case .Bank: return "Счёт"
        case .Deposit: return "Депозит"
        case .Debit: return "Дебетовая карта"
        case .Credit: return "Кредитная карта"
        case .Asset: return "Актив"
        case .Stock: return "Акции"
        case .Income: return "Доход"
        }
    }
    
    var pluralTitle: String {
        switch self {
        case .Cash: return "Наличные"
        case .Bank: return "Счета"
        case .Deposit: return "Депозиты"
        case .Debit: return "Дебетовые карты"
        case .Credit: return "Кредитные карты"
        case .Asset: return "Активы"
        case .Stock: return "Акции"
        case .Income: return "Доходы"
        }
    }
    
    var id: Int {
        switch self {
        case .Cash: return 0
        case .Bank: return 1
        case .Deposit: return 2
        case .Debit: return 3
        case .Credit: return 4
        case .Asset: return 5
        case .Stock: return 6
        case .Income: return 7
        }
    }
}


let typesArray = [Type.Cash, .Bank, .Deposit, .Debit, .Credit, .Asset, .Stock, .Income]
let typeNamesArray:[String] = typesArray.map { $0.title }


/*
var typeNamesArray:[String] {
    var a = [String]()
    for type in typesArray {
        a.append(type.title)
    }
    return a
}
*/