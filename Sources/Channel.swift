//
//  Channel.swift
//  foobar
//
//  Created by KRIS STEIGERWALD on 8/26/17.
//
//

import Foundation
import PerfectRedis

class Channel {
    
    enum Clients {
        case main, publisher, subscriber
    }
    
    static let shared = Channel()
    let namespace: String = "cryptolio"
    var client:RedisClient?
    var subscriber:RedisClient?
    var publisher:RedisClient?
    
    init() {
        setClient(client: .main)
        setClient(client: .publisher)
        setClient(client: .subscriber)
    }
    
    func setClient(client: Clients) {
        RedisClient.getClient(withIdentifier: RedisClientIdentifier()) {
            c in
            do {
                switch client {
                case .main: self.client = try c()
                case .publisher: self.publisher = try c()
                case .subscriber: self.subscriber = try c()
                }
            } catch {
                print("redis err: publisher")
            }
        }
    }
    
    func keySet(_ tokens:String...) -> String {
        var vals: [String] = tokens
        vals.insert(namespace, at: 0)
        return vals.joined(separator: ":")
    }
    
    func set(_ id: String, _ param: String) {
        let sette:String = keySet(id)
        //let (key, value) = (sette, param)
        let (key, value) = ("\(sette)", "\(param)")
        self.client?.set(key: key, value: .string(value))
        {
            response in
            let s = response.toString() as Any
            print(s, "pOST SET")
        }
    }
    
    func get(_ id: String, _ completion: @escaping (_ result: String) -> Void) {
        let key = keySet(id)
        self.client?.get(key: key) {
            response in
            let s:String = response.toString() ?? ""
            completion(s)
        }
        
    }
    
    func pub(channel:String, message: String) {
        Channel.shared.readPub()
        self.publisher?.publish(channel: channel, message: .string(message)) {
            response in
            print(response, "pub")
        }
    }
    
    func readPub() {
        self.subscriber?.subscribe(channels: ["price:update"]) {
            response in
            print("++ subscribed channel ++")
            self.subscriber?.readPublished(timeoutSeconds: 5.0) {
                response in
                guard case .array(let array) = response else {
                    return
                }
                
                let response:[String] = array.map { rsp in rsp.toString() ?? "" }
                
                EventRouter(rawValue: response[1])?.direct()
                
            }
            
        }
    }
    
}
