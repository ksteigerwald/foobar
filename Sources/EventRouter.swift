//
//  EventRouter.swift
//  foobar
//
//  Created by KRIS STEIGERWALD on 8/27/17.
//
//

import Foundation

enum EventRouter:String {
    case priceUpdate = "price:update"
    
    func direct() {
        switch self {
        case .priceUpdate:
            BalanceSheet.shared.updateBalances()
        }
    }
}
