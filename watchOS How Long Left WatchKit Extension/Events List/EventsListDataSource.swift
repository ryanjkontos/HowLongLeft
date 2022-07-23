//
//  EventsListDataSource.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 31/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI

class EventsListDataSource: ObservableObject, EventPoolUpdateObserver, SelectedEventObserver {
    
    var timer: Timer!
    
    var updates = true
    
    @Published var neverUpdated = false
    
    @Published var events = [HLLEvent]()
    
    init() {
        
        checkForChanges()
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(checkForChanges), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        
        
        HLLEventSource.shared.addEventPoolObserver(self)
        SelectedEventManager.shared.observers.append(self)
        
        HLLEventSource.shared.updateEventPool()
        
        
    }
    
    
    @objc func checkForChanges() {
        
        
        
        if !updates {
            return
        }
        
       
        let newEvents = getEvents(at: Date()) ?? [HLLEvent]()
        
        if events != newEvents {
            
            DispatchQueue.main.async {
                
                withAnimation {
                    self.events = newEvents
                    self.objectWillChange.send()
                }
                
            }
            
        }
        
    }
    
    func eventPoolUpdated() {
        
        if !updates {
            return
        }
        
        DispatchQueue.main.async {
        
           
            withAnimation {
            self.objectWillChange.send()
                
            }
        }
        
    }
    
    func selectedEventChanged() {
        checkForChanges()
    }
    
    func getEvents(at date: Date) -> [HLLEvent]? {
        
        if !updates {
            return events
        }
        
        var returnArray = [HLLEvent]()
        let all = HLLEventSource.shared.eventPool
        
        var upcoming = [HLLEvent]()
        var current = [HLLEvent]()
        
        if !(HLLDefaults.watch.upcomingMode == .off) {
            upcoming = HLLEventSource.shared.getUpcomingEventsFromNextDayWithEvents(date: date)
            upcoming.sort(by: { $0.countdownDate(at: date).compare($1.countdownDate(at: date)) == .orderedAscending })
        }
        
        if HLLDefaults.watch.showCurrent {
            current = all.filter({ $0.completionStatus(at: date) == .current })
            current.sort(by: { $0.countdownDate(at: date).compare($1.countdownDate(at: date)) == .orderedAscending })
        }
        
        switch HLLDefaults.watch.listOrderMode {
            
        case .chronological:
            returnArray.append(contentsOf: current)
            returnArray.append(contentsOf: upcoming)
            returnArray.sort(by: { $0.countdownDate(at: date).compare($1.countdownDate(at: date)) == .orderedAscending })
        case .currentFirst:
            returnArray.append(contentsOf: current)
            returnArray.append(contentsOf: upcoming)
        case .upcomingFirst:
            returnArray.append(contentsOf: upcoming)
            returnArray.append(contentsOf: current)
            
        }
        
        if let pinned = SelectedEventManager.shared.selectedEvent {
            returnArray.removeAll(where: { $0 == pinned })
            returnArray.insert(pinned, at: 0)
        }
        
        if !returnArray.isEmpty {
            return returnArray
        }
        
        return nil
        
    }
    
    
}

