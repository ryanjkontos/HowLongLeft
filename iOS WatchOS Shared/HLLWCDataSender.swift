//
//  HLLWCDataSender.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import WatchConnectivity

class HLLWCDataSender {
    
    
    static func send(dict: [String: Any]) {
        
        var sendDict = dict
        
        sendDict["SendDate"] = Date().timeIntervalSinceReferenceDate
        
        // print("Sending WC dict")
        
        WCSession.default.sendMessage(sendDict, replyHandler: nil, errorHandler: { error in
            // print("Error sending WC Message: \(error)")
        })
        
        do {
            try WCSession.default.updateApplicationContext(sendDict)
        } catch {
            // print("Error sending WC context: \(error)")
        }
        
        
        WCSession.default.transferUserInfo(sendDict)
        
    }
    
    
    
}
