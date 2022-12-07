//
//  UpcomingEventSource.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 20/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import Combine

class UpcomingEventSource: ObservableObject, EventSourceProtocol {

    @Published var events = [DateOfEvents]()
    
    var timer: Timer!

    var isEmpty: Bool {
        get {
            return events.isEmpty
        }
    }
    
    var allowUpdates = true
    
    
    init() {
        
        // print("Init UES")
        
        HLLEventSource.shared.addeventsObserver(self)
        
        update()
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func update(force: Bool = false) {
        
        let start = Date().startOfDay()
        let end = start.addDays(100)
        
        let newEvents = HLLEventSource.shared.getArraysOfUpcomingEventsForDates(startDate: start, endDate: end, returnEmptyItems: false)
        if self.events != newEvents {
            self.events = newEvents
        }
        
        if force {
            self.objectWillChange.send()
        }
    
    }

}

extension UpcomingEventSource: EventSourceUpdateObserver {
    
    func eventsUpdated() {
        
        DispatchQueue.main.async {
            self.update()
        }
        
    }
    
}
