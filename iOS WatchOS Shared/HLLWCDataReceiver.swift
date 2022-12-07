//
//  HLLWCDataReceiver.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLWCDataReceiver {
    
    typealias WCDataDictionary = [String:Any]
    
    static var shared = HLLWCDataReceiver()
    
    private var observers = [(HLLWCDataObserver, [String])]()
    
    func register(_ observer: HLLWCDataObserver, forKeys keys: [String]) {
        observers.append((observer, keys))
    }
    
    func register(_ observer: HLLWCDataObserver, forKey key: String) {
        self.register(observer, forKeys: [key])
    }
    
    func handleApplicationContext(context: WCDataDictionary) {
        processDict(dict: context)
    }
    
    func handleMessage(message: WCDataDictionary) {
        processDict(dict: message)
    }
    
    func handleUserInfo(userInfo: WCDataDictionary) {
        processDict(dict: userInfo)
    }
    
    func processDict(dict: WCDataDictionary) {
        
        for pair in dict {
            observers.forEach { (observer, interestedKeys) in
                if interestedKeys.contains(pair.key) {
                    DispatchQueue.main.async {
                        observer.handle(object: pair.value, for: pair.key)
                    }
                }
            }
        }
        
        let date = Date(timeIntervalSinceReferenceDate: dict["SendDate"]! as! TimeInterval)
        let dif = Date().timeIntervalSince(date)
        
        #if os(watchOS)
            ComplicationStatusLogger.log("\(Date().formattedTime()): Got dict sent \(dif) ago")
        #endif
    }
    
    
}

protocol HLLWCDataObserver {
    func handle(object: Any, for key: String)
}

