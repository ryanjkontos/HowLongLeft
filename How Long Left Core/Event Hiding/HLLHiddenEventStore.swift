//
//  HLLHiddenEventStore.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/5/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import CoreData

class HLLHiddenEventStore: ObservableObject {
    
    static var shared = HLLHiddenEventStore()
    var hiddenEvents = [HLLStoredEvent]()
    
    //var equivalentHLLEvents
    
    var observers = [EventHidingObserver]()
    
    init() {
        
     
        NotificationCenter.default.addObserver(self, selector: #selector(contextSaved), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
        
        loadHiddenEventsFromDatabase()
        
    }
    
    func loadHiddenEventsFromDatabase() {
      
       var returnArray = [HLLStoredEvent]()
               
        let managedContext = HLLDataModel.shared.persistentContainer.viewContext
               let fetchRequest: NSFetchRequest<HLLStoredEvent> = HLLStoredEvent.fetchRequest()
               if let items = try? managedContext.fetch(fetchRequest) {
                   returnArray = items
               }
        
        self.hiddenEvents = returnArray
        
        DispatchQueue.main.async {
            HLLEventSource.shared.updateHiddenEvents()
            self.objectWillChange.send()
        }
        
        
    }
    
    func isHidden(event: HLLEvent) -> Bool {
        self.hiddenEvents.contains(where: { $0.identifier == event.persistentIdentifier })
    }
    
    func hideEvent(_ event: HLLEvent) {
        
        DispatchQueue.main.async {
        
        let record = NSEntityDescription.insertNewObject(forEntityName: "HLLStoredEvent", into: HLLDataModel.shared.persistentContainer.viewContext) as! HLLStoredEvent
        record.setup(from: event)
        
        HLLDataModel.shared.save()
            
            self.objectWillChange.send()
            
        }
        
        DispatchQueue.main.async {
            self.observers.forEach({$0.eventWasHidden(event: event)})
        }
        
       
        
    }
    
    func unhideEvent(_ event: HLLStoredEvent) {
        
       
        
            HLLDataModel.shared.persistentContainer.viewContext.delete(event)
            HLLDataModel.shared.save()
      
        
    }
    
    func unhideEvents(_ events: [HLLStoredEvent]) {
        
        
        for event in events {
            
            unhideEvent(event)
            
        }
        
    }
    

    func updateHiddenEvents(from events: [HLLEvent]) {
        
        let hiddenEventItems = hiddenEvents
        
        for event in events {
            
            for stored in hiddenEventItems {
                
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
        
        unhideEvents(delete)
        
    }
    
    @objc func contextSaved() {
        
        DispatchQueue.main.async {
            
            self.loadHiddenEventsFromDatabase()
            HLLEventSource.shared.asyncUpdateEventPool()
            
        }
        
    }
    
    
}

protocol EventHidingObserver {
    
    func eventWasHidden(event: HLLEvent)
    
}
