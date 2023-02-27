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

            // print("Let's pin: \(identifier)")
            
            if let event = CalendarReader.shared.eventStore.event(withIdentifier: identifier) {
                    
                let hllEvent = HLLEvent(event)
                self.pinEvent(hllEvent)
                    
            } else {
                
                for event in HLLEventSource.shared.events {
                    
                    if event.persistentIdentifier == identifier {
                        self.pinEvent(event)
                    }
                    
                }
                
                
            }
            
            }
        
        }
        
    }
    
    func setPinned(_ value: Bool, for event: HLLEvent) {
        
        // print("Setting pinned \(value) for \(event.title)")
        
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
        
        HLLStoredEventManager.shared.pinEvent(inputEvent)
        HLLEventSource.shared.updateEventsAsync()
        
      /*  // print("Pinning \(inputEvent.title)")
        
        var event = inputEvent
        
        if let alreadyContained = HLLEventSource.shared.events.first(where: {$0.persistentIdentifier == event.persistentIdentifier}) {
            
            event = alreadyContained
                           
        } else {
                           
            HLLEventSource.shared.events.append(event)
            
        }

        event.isUserHideable = false
            //SelectedEventManager.shared.selectedEvent = event
                       
                       
        if HLLDefaults.general.pinnedEventIdentifiers.contains(inputEvent.persistentIdentifier) == false {
            HLLDefaults.general.pinnedEventIdentifiers.append(inputEvent.persistentIdentifier)
            }
                       
            HLLEventSource.shared.updateEventsAsync() */
        
        
        }
    
    func unpinEvent(_ event: HLLEvent) {

      /*  // print("Unpinning \(event.title)")
        
        if SelectedEventManager.shared.selectedEvent == event {
            SelectedEventManager.shared.selectedEvent = nil
        }
        
        // print("Count at start: \(HLLDefaults.general.pinnedEventIdentifiers.count)")
        
        HLLDefaults.general.pinnedEventIdentifiers.removeAll { $0 == event.persistentIdentifier }
                     
        // print("Count at end: \(HLLDefaults.general.pinnedEventIdentifiers.count)") */
        
        HLLStoredEventManager.shared.unpinEvent(event)
        HLLEventSource.shared.updateEventsAsync()
        
        
    }
    
    func togglePinned(_ event: HLLEvent) {
        
        DispatchQueue.global(qos: .default).async {
            
            
            if event.isPinned {
                self.unpinEvent(event)
            } else {
                self.pinEvent(event)
            }
            
            EventChangeMonitor.shared.updateAppForChanges()
            
        }
        
    }
    
}



