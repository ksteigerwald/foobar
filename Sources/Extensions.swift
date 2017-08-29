//
//  Extensions.swift
//  foobar
//
//  Created by KRIS STEIGERWALD on 8/27/17.
//
//

import Foundation

extension Decimal {
    
    /// Round `Decimal` number to certain number of decimal places.
    ///
    /// - Parameters:
    ///   - scale: How many decimal places.
    ///   - roundingMode: How should number be rounded. Defaults to `.plain`.
    /// - Returns: The new rounded number.
    
    func rounded(_ scale: Int, roundingMode: RoundingMode = .plain) -> Decimal {
        var value = self
        var result: Decimal = 0
        NSDecimalRound(&result, &value, scale, roundingMode)
        return result
    }
    
}

public extension String {
    
    public func format(_ type: NumberFormatter.Style = .decimal) -> Decimal{
        let formatter = NumberFormatter()
        formatter.numberStyle = type
        
        if let number = formatter.number(from: self) {
            let amount = number.decimalValue
            return amount
        }
        
        return 0.0
    }
    
}

public protocol Memo {}

public extension Memo {
    // Non Recursive
    func memoize<T: Hashable, U>(work: @escaping (T)->U) -> (T)->U {
        var memo = Dictionary<T, U>()
        
        return { x in
            if let q = memo[x] { return q }
            let r = work(x)
            memo[x] = r
            return r
        }
    }

}
