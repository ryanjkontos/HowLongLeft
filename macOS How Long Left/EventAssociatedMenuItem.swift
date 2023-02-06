//
//  EventAssociatedMenuItem.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class EventAssociatedMenuItem {
    
    internal init(item: NSMenuItem, event: HLLEvent?, type: EventAssociatedMenuItemType) {
        self.item = item
        self.event = event
        self.type = type
    }
    
    var item: NSMenuItem
    var event: HLLEvent?
    var type: EventAssociatedMenuItemType
    
    
    
}

enum EventAssociatedMenuItemType {
    
    case current
    case upcoming
    case noCurrent
    case noUpcoming
    
}
