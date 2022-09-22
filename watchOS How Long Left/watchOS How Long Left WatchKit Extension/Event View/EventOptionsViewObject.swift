//
//  EventOptionsViewObject.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 5/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import SwiftUI

class EventOptionsViewObject: ObservableObject {
    
    
    init(_ event: HLLEvent) {
        self.event = event
    }
    
    var event: HLLEvent
    
    var isPinned: Bool {
        
        get {
            
            return event.isPinned
            
        }
        
        set {
        
            EventPinningManager.shared.togglePinned(event)
            self.objectWillChange.send()
            
        }
        
    }
    
    func update() {
        
        HLLEventSource.shared.updateEventPool()
        if let updated = event.getUpdatedInstance() {
            event = updated
            self.objectWillChange.send()
        }
        
        
    }
    
}
