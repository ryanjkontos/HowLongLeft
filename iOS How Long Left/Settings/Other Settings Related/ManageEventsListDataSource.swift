//
//  ManageEventsListDataSource.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

protocol ManageEventsListDataSource {
    
    var addActionWord: String { get }
    
    var removeActionWord: String { get }
    
    var addedWord: String { get }
    
    var addedDescription: String { get }
    
    func addAction(event: HLLEvent)
    
    func removeAction(events: [HLLStoredEvent])
    
    func getAddedEvents() -> [HLLStoredEvent]
    
}


struct HiddenEventsListDataSource: ManageEventsListDataSource {
    
    var addActionWord: String {
        return "Hide"
    }
    
    var removeActionWord: String {
        return "Unhide"
    }
    
    var addedWord: String {
        return "Hidden"
    }
    
    var addedDescription: String {
        return "Hidden events will not appear anywhere in How Long Left, including the widget."
    }
    
    func addAction(event: HLLEvent) {
        HLLStoredEventManager.shared.hideEvent(event)
    }
    
    func removeAction(events: [HLLStoredEvent]) {
        HLLStoredEventManager.shared.unhideEvents(events)
    }
    
    func getAddedEvents() -> [HLLStoredEvent] {
        HLLStoredEventManager.shared.hiddenEvents
    }
    
}

struct PinnedEventsListDataSource: ManageEventsListDataSource {
    
    var addActionWord: String {
        return "Pin"
    }
    
    var removeActionWord: String {
        return "Unpin"
    }
    
    var addedWord: String {
        return "Pinned"
    }
    
    var addedDescription: String {
        return "Pinned events always appear in countdown tab, unless you disable this. You can choose to make Widgets prefer to display pinned events over non-pinned events."
    }
    
    func addAction(event: HLLEvent) {
        HLLStoredEventManager.shared.pinEvent(event)
    }
    
    func removeAction(events: [HLLStoredEvent]) {
        HLLStoredEventManager.shared.unpinEvents(events)
    }
    
    func getAddedEvents() -> [HLLStoredEvent] {
        HLLStoredEventManager.shared.pinnedEvents
    }
    
}
