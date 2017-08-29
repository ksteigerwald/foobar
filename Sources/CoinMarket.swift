//
//  CoinMarket.swift
//  foobar
//
//  Created by KRIS STEIGERWALD on 8/25/17.
//
//

import Foundation
import Jobs
import PerfectLogger
import PerfectCURL

class CoinMarket {
    
    static let shared = CoinMarket()
    
    let coins = Coin()
    var tickers: [String] = []
    var data:[RespData] = []
    
    let url = "https://api.coinmarketcap.com/v1/ticker/"
    
    init() {
        do {
            try coins.findAll()
            self.tickers = coins.all().map { coin in coin.symbol }
        }
        catch {}
    }
    
    func poll() {
        Jobs.add(interval: .seconds(4)) {
            print("👋 I'm printed every 4 seconds!")
            self.requestor()
        }
    }
    
    func convertToDictionary(text: String) throws -> [RespData]? {
        
        if let data = text.data(using: .utf8) {
            do {
                let json:[[String : AnyObject]] = try JSONSerialization.jsonObject(with: data, options: []) as! [[String:AnyObject]]
                return json
                        .filter { self.tickers.contains($0["symbol"] as! String) }
                        .map { return RespData(json: $0) }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return []
        
    }
    
    func requestor(_ token: String = "") -> Void {
        
        do {
            let resp:String = try CURLRequest(url).perform().bodyString
            let json:[RespData] = try convertToDictionary(text: resp) ?? []
            
            self.data = json
                .map {
                    var copy = $0
                    copy.local_coin_id = self.coins.getId($0.symbol)
                    return copy
                }
            
            Channel.shared.pub(channel: "price:update", message: "All Coins")
        }
        catch {
            LogFile.debug("JSON from Coin Market failed to load", logFile: "test.txt")
        }
        
    }
    
    
}


struct RespData {
    var id:String = ""
    var name:String = ""
    var symbol:String = ""
    var rank:Int = 0
    var price_usd:Float = 0.0
    var price_btc:Float = 0.0
    var volume_usd:Float = 0.0
    var market_cap_usd:Float = 0.0
    var available_supply:Float = 0.0
    var total_supply:Float = 0.0
    var percent_change_1h:Float = 0.0
    var percent_change_24h:Float = 0.0
    var percent_change_7d:Float = 0.0
    var last_updated:String = ""
   
    var local_coin_id:Int = 0
    var local_allocations:Float = 0.0
    var local_target_allocations:Int = 0
   
    init(json:[String: AnyObject]) {
        self.id = json["id"]                                                    as! String!  ?? ""
        self.name = json["name"]                                                as! String!  ?? ""
        self.symbol = json["symbol"]                                            as! String!  ?? ""
        self.rank = (json["rank"] as! NSString).integerValue
        self.price_usd = (json["price_usd"] as! NSString).floatValue
        self.price_btc = (json["price_btc"] as! NSString).floatValue
        self.volume_usd = (json["24h_volume_usd"] as! NSString).floatValue
        self.market_cap_usd = (json["market_cap_usd"] as! NSString).floatValue
        self.available_supply = (json["available_supply"] as! NSString).floatValue
        self.total_supply = (json["total_supply"] as! NSString).floatValue
        self.percent_change_1h = (json["percent_change_1h"] as! NSString).floatValue
        self.percent_change_24h = (json["percent_change_24h"] as! NSString).floatValue
        self.percent_change_7d = (json["percent_change_7d"] as! NSString).floatValue
        self.last_updated = json["last_updated"] as! String
        
    }
   
    
    
}

extension RespData {
}


