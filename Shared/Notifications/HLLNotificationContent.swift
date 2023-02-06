//
//  HLLNotificationContent.swift
//  How Long Left
//
//  Created by Ryan Kontos on 22/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLNotificationContent {
    
    internal init(date: Date, event: HLLEvent? = nil) {
        self.date = date
    }
    
    var date: Date
    var title: String?
    var subtitle: String?
    var body: String?
    var userInfo = [AnyHashable:Any]()
    var event: HLLEvent? {
        
        didSet {
            
            if let safeEvent = event {
                self.event = safeEvent
                userInfo["eventidentifier"] = safeEvent.persistentIdentifier
            }

            
        }
        
    }
    
}
