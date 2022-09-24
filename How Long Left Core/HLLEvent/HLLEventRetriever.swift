//
//  HLLEventRetriever.swift
//  How Long Left (macOS)
//
//  Created by Ryan on 29/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

protocol HLLEventRetriever {
    
    func retrieveEvent() -> HLLEvent?
    
}

class HLLEventRetrieverPersistent: HLLEventRetriever {
    
    var event: HLLEvent
    
    init(_ event: HLLEvent) {
        self.event = event
    }
    
    func retrieveEvent() -> HLLEvent? {
        
        if let updatedEvent = self.event.getUpdatedInstance() {
            self.event = updatedEvent
        }
        
        if HLLStoredEventManager.shared.hiddenEvents.contains(where: { $0.identifier == event.persistentIdentifier }) {
            return nil
        }
        
        return self.event
    }
  
}

class HLLEventRetrieverMain: HLLEventRetriever {

    
    func retrieveEvent() -> HLLEvent? {
        return HLLEventSource.shared.getPrimaryEvent()
    }
  
}
