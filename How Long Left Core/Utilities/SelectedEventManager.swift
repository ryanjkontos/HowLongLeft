//
//  SelectedEventManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class SelectedEventManager: EventPoolUpdateObserver {
    
    var observers = [SelectedEventObserver]()
    
    static var shared = SelectedEventManager()
    var timer: Timer!
    
    var launchID: String?
    
    init() {
        
      launchID = HLLDefaults.defaults.string(forKey: "SelectedEvent")
        
        HLLEventSource.shared.addEventPoolObserver(self)
       // timer = Timer(timeInterval: 1, target: self, selector: #selector(updateEvent), userInfo: nil, repeats: true)
    }
    
    var selectedEvent: HLLEvent? {
        
        set (to) {
            
          //  print("Selected set!")
            
            if let event = to {
                
                if event.completionStatus == .done {
                    
                    SelectedEventManager.shared.selectedEvent = nil
                     print("SelectedSet 4")
                    HLLDefaults.defaults.set(nil, forKey: "SelectedEvent")
                    return
                    
                }
                
                let id = event.persistentIdentifier
                
                 HLLDefaults.defaults.set(id, forKey: "SelectedEvent")
                
            } else {
                
                HLLDefaults.defaults.set(nil, forKey: "SelectedEvent")
                
            }
            
            #if !os(watchOS)
            
            WidgetUpdateHandler.shared.updateWidget(force: true)
            
            #endif
            
            DispatchQueue.main.async {
                self.observers.forEach({$0.selectedEventChanged()})
            }
            
        }
        
        get {
            
            if let id = HLLDefaults.defaults.string(forKey: "SelectedEvent") {
                
                return HLLEventSource.shared.eventPool.first(where: {$0.persistentIdentifier == id})
                
            }
            
            return nil
            
        }
        
    }
    
    func setSelection(_ value: Bool, for event: HLLEvent) {
        
        if value {
           
            if event.isSelected == false {
                selectedEvent = event
            }
            
        } else {
            
            if event.isSelected {
                selectedEvent = nil
            }
            
        }
        
        
        
    }
    
    func toggleSelection(for event: HLLEvent) {
        
        if SelectedEventManager.shared.selectedEvent == event {
           SelectedEventManager.shared.selectedEvent = nil
        } else {
            SelectedEventManager.shared.selectedEvent = event
        }
        
    }
    
    func eventPoolUpdated() {
        DispatchQueue.global().async {
            self.updateEvent()
        }
    }
    
    @objc func updateEvent() {
        
        if let id = launchID {
            
            if let event = HLLEventSource.shared.findEventWithIdentifier(id: id) {
                
                SelectedEventManager.shared.selectedEvent = event
                
            }
            
            launchID = nil
            
        }
        
        
         
    }
    
}

protocol SelectedEventObserver {
    
    func selectedEventChanged()
    
}
