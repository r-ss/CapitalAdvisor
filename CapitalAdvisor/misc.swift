//
//  misc.swift
//  CapitalAdvisor
//
//  Created by Alex Antipov on 24/09/15.
//  Copyright © 2015 Alex Antipov. All rights reserved.
//

//func nameToType(type:Type) -> String {
//    switch type {
//    case .Bank:
//        return "Счёт"
//    case .Deposit:
//        return "Депозит"
//    case .Debit:
//        return "Дебетовая карта"
//    case .Credit:
//        return "Кредитная карта"
//    case .Asset:
//        return "Актив"
//    case .Income:
//        return "Доход"
//    default:
//        return "Наличные"
//    }
//}

import Foundation


func typeToInt(type:Type) -> Int {
    switch type {
    case .Bank:
        return 1
    case .Deposit:
        return 2
    case .Debit:
        return 3
    case .Credit:
        return 4
    case .Asset:
        return 5
    case .Income:
        return 6
    default:
        return 0
    }
}

func intToType(int:Int) -> Type {
    switch int {
    case 1:
        return .Bank
    case 2:
        return .Deposit
    case 3:
        return .Debit
    case 4:
        return .Credit
    case 5:
        return .Asset
    case 6:
        return .Income
    default:
        return .Cash
    }
}

func currencyToInt(currency: Currency) -> Int {
    switch currency {
    case .USD:
        return 1
    case .EUR:
        return 2
    default:
        return 0
    }
}

func intToCurrency(int: Int) -> Currency {
    switch int {
    case 1:
        return .USD
    case 2:
        return .EUR
    default:
        return .RUB
    }
}