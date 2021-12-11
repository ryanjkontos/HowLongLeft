//
//  DateOfEvents.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


struct DateOfEvents: Equatable, Identifiable, Hashable {
    
    
    
    var id: String {
        
        get {
        
            let reducedIDS = "\(events.reduce("", { return "\($0)\($1.infoIdentifier)" }))"
            return "\(date)\(reducedIDS)"
            
        }
    }
    
    static func == (lhs: DateOfEvents, rhs: DateOfEvents) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    var headerString: String?
    var date: Date
    var events: [HLLEvent]
    
    init(date: Date, events: [HLLEvent]) {
        
        self.date = date
        self.events = events
        
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(id)
        
    }
    
}
