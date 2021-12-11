//
//  IntentHandler.swift
//  WidgerCalendarSelectionInteny
//
//  Created by Ryan Kontos on 21/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Intents
import EventKit

class IntentHandler: INExtension, HLLWidgetIntentHandling {
    func resolveCalendar(for intent: HLLWidgetIntent, with completion: @escaping ([HLLCalendarResolutionResult]) -> Void) {
       
    }
    
    
    
    let store = EKEventStore()
    
    override init() {
        
        store.requestAccess(to: .event, completion: {_,_ in
            
            
            
            
        })
        
    }
    
 
    
    func provideCalendarOptionsCollection(for intent: HLLWidgetIntent, with completion: @escaping (INObjectCollection<HLLCalendar>?, Error?) -> Void) {
        
        var array = [HLLCalendar]()
        for cal in store.calendars(for: .event) {
            array.append(HLLCalendar(identifier: cal.calendarIdentifier, display: cal.title))
        }
        
        
        let objects = INObjectCollection(items: array)
        
       completion(objects, nil)
        
    }
    
    
    
 

    
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
