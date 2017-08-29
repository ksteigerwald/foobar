//
//  Holding.swift
//  foobar
//
//  Created by KRIS STEIGERWALD on 8/26/17.
//
//

import Foundation
import PostgresStORM
import StORM

class Holding: PostgresStORM {
    
    var id                :Int       = 0
    var coin_id           :Int       = 0
    var target_allocation :Int       = 0
    var allocation        :Float     = 0.0
    
    // The name of the database table
    override open func table() -> String { return "holdings" }
    
    
    // The mapping that translates the database info back to the object
    // This is where you would do any validation or transformation as needed
    override func to(_ this: StORMRow) {
        id                  = this.data["id"] as? Int                        ?? 0
        coin_id             = this.data["coin_id"] as? Int                   ?? 0
        allocation          = this.data["allocation"] as? Float              ?? 0.0
        target_allocation   = this.data["target_allocation"] as? Int         ?? 0
    }
    
    func all() -> [Holding] {
        return self.results.rows.map { holding in
            let _holding:Holding = Holding()
            _holding.to(holding)
            return _holding
        }
    }
    
    func find() -> [Holding] {
        return self.results.rows.map { holding in
            let _holding:Holding = Holding()
            _holding.to(holding)
            return _holding
        }
    }
}
