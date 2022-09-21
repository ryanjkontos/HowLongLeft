//
//  HLLComplicationEntry.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 18/4/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class HLLComplicationEntry {
    
    var showAt: Date
    var event: HLLEvent?
    var nextEvent: HLLEvent?
    var switchToNext = true
    
    init(date: Date, event currentEvent: HLLEvent?, next: HLLEvent?) {
        showAt = date
        event = currentEvent
        nextEvent = next
    }
    
}
