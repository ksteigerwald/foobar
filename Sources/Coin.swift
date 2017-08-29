//
//  Coin.swift
//  foobar
//
//  Created by KRIS STEIGERWALD on 8/25/17.
//
//

import Foundation
import PostgresStORM
import StORM

class Coin: PostgresStORM {
    
    var id: Int = 0
    var token:String = ""
    var name:String = ""
    var symbol:String = ""
    var rank:String = ""
    var price_usd:NSDecimalNumber = 0.0
    var price_btc:Decimal = 0.0
    var day_volume_usd:Decimal = 0.0
    var market_cap_usd:Decimal = 0.0
    var available_supply:Decimal = 0.0
    
    // The name of the database table
    override open func table() -> String { return "coins" }
    
    
    // The mapping that translates the database info back to the object
    // This is where you would do any validation or transformation as needed
    override func to(_ this: StORMRow) {
        
        id                  = this.data["id"] as? Int                        ?? 0
        token               = this.data["token"] as? String                  ?? ""
        name                = this.data["name"] as? String                   ?? ""
        symbol              = this.data["symbol"] as? String                 ?? ""
        rank                = this.data["rank"] as? String                   ?? ""
        price_usd           = this.data["price_usd"] as? NSDecimalNumber     ?? 0.0
        price_btc           = this.data["price_btc"] as? Decimal             ?? 0.0
        day_volume_usd      = this.data["day_volume_usd"] as? Decimal        ?? 0.0
        market_cap_usd      = this.data["market_cap_usd"] as? Decimal        ?? 0.0
        available_supply    = this.data["available_supply"] as? Decimal      ?? 0.0
    }
    
    func all() -> [Coin] {
        return self.results.rows.map { coin in
            let _coin:Coin = Coin()
            _coin.to(coin)
            return _coin
        }
    }
    
    func getId(_ ticker: String) -> Int {
        let obj:Coin = all().filter{ $0.symbol == ticker }[0]
        return obj.id
    }
    
    func rows() -> [String] {
        //var rows = [String]()
        for i in 0..<self.results.rows.count {
            print(self.results.rows[i].data)
//            let row = Coin()
//            row.to(self.results.rows[i])
//            print(row)
//            rows.append(row)
        }
        return []
    } 
    
}

