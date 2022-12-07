//
//  EventsListDataSource.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 31/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI

class EventsListDataSource: ObservableObject, EventSourceUpdateObserver, SelectedEventObserver {
    
    var timer: Timer!
    
    var updates = true
    
    var neverUpdated = false
    
    var previous = [TitledEventGroup]()
    
    var currentIsOverLimit = false
     var upcomingIsOverLimit = false
    
    init() {
        
        checkForChanges()
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(checkForChanges), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        
        
        HLLEventSource.shared.addeventsObserver(self)
        SelectedEventManager.shared.observers.append(self)
        
        HLLEventSource.shared.updateEvents()
        
        
    }
    
    
    @objc func checkForChanges() {
        
        
        DispatchQueue.global(qos: .background).async {
            
            if !self.updates { return }
            let newGroups = self.getEventGroups(at: Date()) ?? [TitledEventGroup]()
            
            if self.previous != newGroups {
                
                DispatchQueue.main.async {
                    
                    withAnimation {
                        self.previous = newGroups
                        self.objectWillChange.send()
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func eventsUpdated() {
        
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
        
        currentIsOverLimit = false
        upcomingIsOverLimit = false
        
        var returnArray = [TitledEventGroup]()
        var all = HLLEventSource.shared.events.filter({$0.completionStatus(at: date) != .done})
        
        let upcomingData =  HLLEventSource.shared.getAllEventsGroupedByDate(nil, maxCount: HLLDefaults.watch.upcomingLimit, upcomingOnly: true, at: date, excludePinned: true, groupMode: .startDate)
       
        var upcoming = [TitledEventGroup]()
        var current = [HLLEvent]()
        
        if !(HLLDefaults.watch.upcomingMode == .off) {
           
            for dateOf in upcomingData {
                upcoming.append(TitledEventGroup(title: "Upcoming \(dateOf.date.userFriendlyRelativeString(at: date))", events: dateOf.events))
            }
            
        
        } else {
            all.removeAll(where: { $0.completionStatus(at: date) == .upcoming })
        }
        
        if (currentIsOverLimit) { currentIsOverLimit = false }
        
        if HLLDefaults.watch.showCurrent {
            current = all.filter({ $0.completionStatus(at: date) == .current })
            
            if current.count > HLLDefaults.watch.currentLimit && HLLDefaults.watch.currentLimit != 0 {
                current = Array(current.prefix(HLLDefaults.watch.currentLimit))
                if !currentIsOverLimit { currentIsOverLimit = true }
                
            }
            
            current.sort(by: { $0.countdownDate(at: date).compare($1.countdownDate(at: date)) == .orderedAscending })
        } else {
            all.removeAll(where: { $0.completionStatus(at: date) == .current })
        }
        
        let pinned = HLLEventSource.shared.getPinnedEventsFromevents()
        current.removeAll(where: { pinned.contains($0) })
        //upcoming.removeAll(where: { pinned.contains($0) })
        
        //pinned.removeAll(where: {$0.completionStatus(at: date) == .done})
        
       // let upcomingText = upcomingData.0.userFriendlyRelativeString(at: date)
        
        switch HLLDefaults.watch.listOrderMode {
            
        case .chronological:
            
            let chronoData = filterAllEvents(events: all, at: date).groupedByDate(at: date, sortMode: .countdownDate)
            
            if HLLDefaults.watch.groupEventsByDate {
                for dateOf in chronoData {
                    returnArray.append(TitledEventGroup(title: getDateHeader(for: dateOf.date, at: date), events: dateOf.events))
                }
            } else {
                returnArray.append(TitledEventGroup(events: chronoData.flatMap({$0.events})))
            }
            
           
            
        case .currentFirst:
            
            if !current.isEmpty {
                returnArray.append(TitledEventGroup(title: "In-Progress", events: current, status: .current))
            }
            
            if HLLDefaults.watch.groupEventsByDate {
                
                if !upcoming.isEmpty {
                    returnArray.append(contentsOf: upcoming)
                }
                
            } else {
                returnArray.append(TitledEventGroup(title: "Upcoming", events: upcoming.flatMap({$0.events})))
            }
            
        case .upcomingFirst:
            
            
            if HLLDefaults.watch.groupEventsByDate {
                
                if !upcoming.isEmpty {
                    returnArray.append(contentsOf: upcoming)
                }
                
            } else {
                returnArray.append(TitledEventGroup(title: "Upcoming", events: upcoming.flatMap({$0.events})))
            }
            
            
            if !current.isEmpty {
                returnArray.append(TitledEventGroup(title: "In-Progress", events: current, status: .current))
            }
            
        }
        
        if !pinned.isEmpty {
            returnArray.insert(TitledEventGroup(title: "Pinned", events: pinned), at: 0)
        }
        
        if !returnArray.isEmpty {
            return returnArray
        }
        
        return nil
        
    }
    
    func filterAllEvents(events: [HLLEvent], at date: Date) -> [HLLEvent] {
        
        var currentRemovalCount = events.filter({ $0.completionStatus(at: date) == .current }).count - HLLDefaults.watch.currentLimit
        if currentRemovalCount < 0 { currentRemovalCount = 0 }
        
        var upcomingRemovalCount = events.filter({ $0.completionStatus(at: date) == .upcoming }).count - HLLDefaults.watch.upcomingLimit
        if upcomingRemovalCount < 0 { upcomingRemovalCount = 0 }
        
        var currentRemoved = 0
        var upcomingRemoved = 0
        
        let reversed = events.sortedEvents(mode: .countdownDate, at: date).reversed()
        
        var newArray = [HLLEvent]()
        
        for event in reversed {
            
            switch event.completionStatus(at: date) {
                
                
            case .upcoming:
                
                if upcomingRemoved >= upcomingRemovalCount {
                    newArray.append(event)
                } else {
                    upcomingRemoved += 1
                }
                
            case .current:
                
                if currentRemoved >= currentRemovalCount {
                    newArray.append(event)
                } else {
                    currentRemoved += 1
                }
                
            case .done:
                break
            }
            
        }
        
        return newArray.reversed()
        
    }
    
    
    
    func getDateHeader(for date: Date, at: Date) -> String {
        
        let num = date.daysUntil(at: at)
        
        if num == 0 {
            return "Today"
        }
        
        if num == 1 {
            return "Tomorrow"
        }
        
        return "\(date.userFriendlyRelativeString(at: at)) – in \(num) days"
        
    }
    
}

