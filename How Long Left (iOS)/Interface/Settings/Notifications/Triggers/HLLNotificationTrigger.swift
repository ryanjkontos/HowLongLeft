//
//  HLLNotificationTrigger.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 30/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


protocol HLLNotificationTrigger {
   
    var userString: String { get set }
    var removeTriggerAction: ( () -> Void ) { get set }
    var type: HLLNotificationTriggerType { get set }
    var value: Int? { get set }
    func isEnabled() -> Bool
    
}
