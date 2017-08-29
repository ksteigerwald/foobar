//
//  Balances.swift
//  foobar
//
//  Created by KRIS STEIGERWALD on 8/26/17.
//
//

import Foundation
import PerfectRedis

struct Balance {
    
    enum BalanceType:String {
        case usd = "USD", btc = "BTC"
    }
    
    let symbol: String
    let usd: Float
    let btc: Float
    let target: Float
    
    func format(kind: BalanceType) -> String {
        switch kind {
        case .usd: return "\(usd)".format().rounded(2).description
        case .btc: return "\(btc)".format().rounded(8).description
        }
    }
    
    // (TOTAL + CASH-IN) * TARGET-ALLOCATION - USD-ALLOCATION
    func buySell(total: Float, cash: Float = 0.0) -> Float {
        let base:Float = cash == 0.0 ? total : total * cash
        return round((base) * target - usd)
    }
    
}

struct Total {
    let target: Float
    let amount: Float
    let current: Float
}

class BalanceSheet: Memo {
    
    static let shared = BalanceSheet()
    var balances:[Balance] = []
    let holdings:Holding = Holding()
    var totals:Total?
    
    var cashIn: Float = 0.0
    
    init() {}
    
    func updateBalances() {
        setCashIn()
        do {
            try holdings.findAll()
            balances = holdings.all().map(make)
            totals = enumberateTotal()
        } catch {
            print("load error for holdings")
        }
    }
   
    func make(_ holding: Holding) -> Balance {
        let data:RespData = CoinMarket.shared.data.filter { $0.local_coin_id == holding.coin_id }.first!
        
        let usd: Float = data.price_usd * holding.allocation
        let btc: Float = data.price_btc * holding.allocation
        
        let obj = Balance(symbol: data.symbol, usd: usd, btc: btc, target: holding.target_allocation)
        
        Channel.shared.set("\(data.symbol):balance:usd", obj.format(kind: .usd))
        Channel.shared.set("\(data.symbol):balance:btc", obj.format(kind: .btc))
        
        return obj
    }
    
    func enumberateTotal() -> Total {
        let usd = balances.map{ return round($0.usd) }
                          .reduce(0.0) {return $0 + $1 }
        
        let target = balances.reduce(0.0) { return $0 + $1.target }
        
        return Total(target: target, amount: 0, current: usd)
    }
    
    func setCashIn() {
        Channel.shared.get("cash:in"){ val in
            guard let cash:Float = Float(val) else {
                self.cashIn = 0.0
                return
            }
            self.cashIn = cash
        }
    }
    
}
