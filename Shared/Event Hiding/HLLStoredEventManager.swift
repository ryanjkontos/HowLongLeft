//
//  HLLStoredEventManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/5/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import CoreData

class HLLStoredEventManager: ObservableObject {
    
    static var shared = HLLStoredEventManager()
    var storedEvents = [HLLStoredEvent]()
    
    var hiddenEvents: [HLLStoredEvent] {
        return storedEvents.filter({$0.isHidden})
    }
    
    var pinnedEvents: [HLLStoredEvent] {
        return storedEvents.filter({$0.isPinned})
    }
    
    var observers = [EventHidingObserver]()
    
    init() {
        
      
            
            NotificationCenter.default.addObserver(
                self, selector: #selector(type(of: self).contextSaved),
                name: .NSPersistentStoreRemoteChange,
                object: nil
            )
            
            NotificationCenter.default.addObserver(self, selector: #selector(contextSaved), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
            loadStoredEventsFromDatabase()
            
        
        
    }
    
    func loadStoredEventsFromDatabase() {
      
       var returnArray = [HLLStoredEvent]()
               
        if HLLDataModel.shared.storeLoaded == false {
            return
        }
        
        let managedContext = HLLDataModel.shared.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<HLLStoredEvent> = HLLStoredEvent.fetchRequest()
            if let items = try? managedContext.fetch(fetchRequest) {
            returnArray = items
        }
        
        self.storedEvents = returnArray
        
        DispatchQueue.main.async {
            HLLEventSource.shared.updateHiddenEvents()
            self.objectWillChange.send()
        }
        
        
    }
    
    func isHidden(event: HLLEvent) -> Bool {
        self.hiddenEvents.contains(where: { $0.identifier == event.persistentIdentifier })
    }
    
    func isPinned(event: HLLEvent) -> Bool {
        self.pinnedEvents.contains(where: { $0.identifier == event.persistentIdentifier })
    }
    
    
    func pinEvent(_ event: HLLEvent) {
        

        
            let stored = self.getStoredEvent(for: event)
            stored.isPinned = true
            
            HLLDataModel.shared.save()
            self.objectWillChange.send()
            
        
        HLLEventSource.shared.updateEventsAsync(bypassDebouncing: true)
    }
    
    func unpinEvent(_ event: HLLEvent) {
        
        if let stored = storedEvents.first(where: {$0.identifier == event.persistentIdentifier}) {
            unpinEvent(stored)
        }
        
    }
    
    func unpinEvent(_ event: HLLStoredEvent, _ update: Bool = true) {
        
        event.isPinned = false
        HLLDataModel.shared.persistentContainer.viewContext.delete(event)
        HLLDataModel.shared.save()
        HLLEventSource.shared.updateEventsAsync(bypassDebouncing: true)
    }
    
    func unpinEvents(_ events: [HLLStoredEvent]) {
        
        for event in events {
            unpinEvent(event, false)
        }
        
    }
    
    
    
    func hideEvent(_ event: HLLEvent, update: Bool = true) {
        
       
        
            let stored = self.getStoredEvent(for: event)
           stored.isHidden = true
           
            HLLDataModel.shared.save()
            self.objectWillChange.send()
            
            self.observers.forEach({$0.eventWasHidden(event: event)})
            
        if update {
            HLLEventSource.shared.updateEventsAsync(bypassDebouncing: true)
        }
        
    }
    
    

    
    func unhideEvent(_ event: HLLStoredEvent) {
        
        unhideEventWithoutUpdate(event)
        HLLEventSource.shared.updateEventsAsync(bypassDebouncing: true)
        
    }
    
    private func unhideEventWithoutUpdate(_ event: HLLStoredEvent) {
        event.isHidden = false
        HLLDataModel.shared.persistentContainer.viewContext.delete(event)
       HLLDataModel.shared.save()
    }
    
    func unhideEvents(_ events: [HLLStoredEvent], _ update: Bool = true) {
        
        for event in events {
            unhideEventWithoutUpdate(event)
        }
        
        if update {
            
            HLLEventSource.shared.updateEventsAsync(bypassDebouncing: true)
            
        }
        
    }
    
    
    func getStoredEvent(for event: HLLEvent) -> HLLStoredEvent {
        
        var returnEvent: HLLStoredEvent
        
        if let existing = storedEvents.first(where: {$0.identifier == event.persistentIdentifier}) {
            returnEvent = existing
        } else {
            let record = NSEntityDescription.insertNewObject(forEntityName: "HLLStoredEvent", into: HLLDataModel.shared.persistentContainer.viewContext) as! HLLStoredEvent
            record.setup(from: event)
            returnEvent = record
            self.storedEvents.append(record)
        }
        
        return returnEvent
        
    }

    func updateStoredEvents(from events: [HLLEvent]) {
        
        removeEndedEvents()
        
        let storedEventItems = storedEvents
        
        for event in events {
            
            for stored in storedEventItems {
                
                if stored.identifier == event.persistentIdentifier {
                    
                    stored.setup(from: event)

                }
                
            }
            
            
        }
     
      
     
        
    }
    

    func removeEndedEvents() {
        
        var delete = [HLLStoredEvent]()
        let hiddenEventItems = hiddenEvents
        
        for hidden in hiddenEventItems {
            
            if let date = hidden.endDate {
                
                if date.timeIntervalSince(CurrentDateFetcher.currentDate) < 0 {
                    
                    delete.append(hidden)
                    
                }
                
            }
            
            
        }
        
        if delete.isEmpty == false {
            unhideEvents(delete, false)
        }
        
        
        
    }
    
    @objc func contextSaved() {
        
        // print("Stored Event Context Saved")
        
        DispatchQueue.main.async {
            
            self.loadStoredEventsFromDatabase()
            HLLEventSource.shared.updateEventsAsync()
            
        }
        
    }
    
    
}

protocol EventHidingObserver {
    
    func eventWasHidden(event: HLLEvent)
    
}

