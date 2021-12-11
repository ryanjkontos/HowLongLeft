//
//  EventPinningManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 14/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class EventPinningManager {
    
    static var shared = EventPinningManager()
    
    
    func pinEvents(with identifiers: [String]) {
        
        DispatchQueue.global().async {
        
        for identifier in identifiers {

            print("Let's pin: \(identifier)")
            
            if let event = HLLEventSource.shared.eventStore.event(withIdentifier: identifier) {
                    
                let hllEvent = HLLEvent(event: event)
                self.pinEvent(hllEvent)
                
               
                    
            } else {
                
                for event in HLLEventSource.shared.eventPool {
                    
                    if event.persistentIdentifier == identifier {
                        self.pinEvent(event)
                    }
                    
                }
                
                
            }
            
            }
        
        }
        
    }
    
    func setPinned(_ value: Bool, for event: HLLEvent) {
        
        print("Setting pinned \(value) for \(event.title)")
        
        if value {
           
            if event.isPinned == false {
                pinEvent(event)
            }
            
        } else {
            
            if event.isPinned {
                unpinEvent(event)
            }
            
        }
        
        
        
    }
    
    func pinEvent(_ inputEvent: HLLEvent) {
        
        
        var event = inputEvent
        
        if let alreadyContained = HLLEventSource.shared.eventPool.first(where: {$0.persistentIdentifier == event.persistentIdentifier}) {
            
            event = alreadyContained
                           
        } else {
                           
            HLLEventSource.shared.eventPool.append(event)
            
        }
                       
           
        event.isPinned = true
        event.isUserHideable = false
            //SelectedEventManager.shared.selectedEvent = event
                       
                       
        if HLLDefaults.general.pinnedEventIdentifiers.contains(inputEvent.persistentIdentifier) == false {
            HLLDefaults.general.pinnedEventIdentifiers.append(inputEvent.persistentIdentifier)
            }
                       
            HLLEventSource.shared.asyncUpdateEventPool()
        
        
        }
    
    func unpinEvent(_ event: HLLEvent) {

        print("Unpinning \(event.title)")
        
        if SelectedEventManager.shared.selectedEvent == event {
            SelectedEventManager.shared.selectedEvent = nil
        }
        
        HLLDefaults.general.pinnedEventIdentifiers.removeAll { $0 == event.persistentIdentifier }
                     
        
        HLLEventSource.shared.asyncUpdateEventPool()
        
        
    }
    
}



