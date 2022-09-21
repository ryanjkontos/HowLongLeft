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
    
    @Published var previous = [TitledEventGroup]()
    
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
        
       
        let newGroups = getEventGroups(at: Date()) ?? [TitledEventGroup]()
        
        if previous != newGroups {
            
            DispatchQueue.main.async {
                
                withAnimation {
                    self.previous = newGroups
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
    
    func getEventGroups(at date: Date) -> [TitledEventGroup]? {
        
        if !updates {
            return previous
        }
        
        var returnArray = [TitledEventGroup]()
        var all = HLLEventSource.shared.eventPool
        
       
       
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
        
        if let pinned = SelectedEventManager.shared.selectedEvent {
            current.removeAll(where: { $0 == pinned })
            upcoming.removeAll(where: { $0 == pinned })
        }
        
        switch HLLDefaults.watch.listOrderMode {
            
        case .chronological:
            
            var chronoArray = [HLLEvent]()

            chronoArray.append(contentsOf: current)
            chronoArray.append(contentsOf: upcoming)
            chronoArray.sort(by: { $0.countdownDate(at: date).compare($1.countdownDate(at: date)) == .orderedAscending })
            
            returnArray.append(TitledEventGroup(events: chronoArray))
            
        case .currentFirst:
            
            if !current.isEmpty {
                returnArray.append(TitledEventGroup(title: "In Progress", events: current))
            }
            
            if !upcoming.isEmpty {
                returnArray.append(TitledEventGroup(title: "Upcoming", events: upcoming))
            }
            
        case .upcomingFirst:
            
            if !upcoming.isEmpty {
                returnArray.append(TitledEventGroup(title: "Upcoming", events: upcoming))
            }
            
            if !current.isEmpty {
                returnArray.append(TitledEventGroup(title: "In Progress", events: current))
            }
            
        }
        
        if let pinned = SelectedEventManager.shared.selectedEvent {
            returnArray.insert(TitledEventGroup(title: "Pinned", events: [pinned]), at: 0)
        }
        
        if !returnArray.isEmpty {
            return returnArray
        }
        
        return nil
        
    }
    
    
}

