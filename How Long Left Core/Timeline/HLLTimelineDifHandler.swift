//
//  HLLTimelineDifHandler.swift
//  How Long Left
//
//  Created by Ryan Kontos on 2/12/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLTimelineDifHandler {
    
    func exportTimelineToDefaults(timeline: HLLTimeline, for type: TimelineType) {
        
        let dataDict = generateTimelineDict(from: timeline)
        HLLDefaults.defaults.set(dataDict, forKey: TimelineDictKey.widgetDictKey.rawValue)
        
    }
    
    private func getLatestStoredTimeline() -> HLLTimelineInfo? {
        
        if let dict = HLLDefaults.defaults.dictionary(forKey: TimelineDictKey.widgetDictKey.rawValue) {
            return convertDictToTimelineInfo(dict: dict)
        }
        
        return nil
        
    }
    
    private func generateTimelineDict(from timeline: HLLTimeline) -> [String: Any] {
        
        var dataDict = [String: Any]()
        var eventDict = [String:String]()
        
        for event in timeline.includedEvents {
            eventDict[event.persistentIdentifier] = event.infoIdentifier
        }
        
        dataDict[TimelineDictKey.eventsKey.rawValue] = eventDict
        dataDict[TimelineDictKey.lastDateKey.rawValue] = timeline.entries.last!.showAt
        dataDict[TimelineDictKey.state.rawValue] = timeline.state.rawValue
        
        return dataDict
        
        
    }
    
    private func convertDictToTimelineInfo(dict: [String: Any]) -> HLLTimelineInfo? {
        
        
        if let eventsDict = (dict[TimelineDictKey.eventsKey.rawValue] as? [String:String]), let lastDate = (dict[TimelineDictKey.lastDateKey.rawValue] as? Date), let stateKey = (dict[TimelineDictKey.state.rawValue] as? String), let state = TimelineState(rawValue: stateKey) {
            return HLLTimelineInfo(state: state, endDate: lastDate, eventIDS: eventsDict)
        }
        
        return nil
        
        
    }
    
    private func convertTimelineToTimelineInfo(timeline: HLLTimeline) -> HLLTimelineInfo? {
        
        let dict = generateTimelineDict(from: timeline)
        if let info = convertDictToTimelineInfo(dict: dict) { return info }
        return nil
        
    }
    
    func shouldUpdateTo(newtimeline timeline: HLLTimeline) -> Bool {
        
        var dif = false
        
        if let stored = getLatestStoredTimeline(), let timelineInfo = convertTimelineToTimelineInfo(timeline: timeline) {
            
            if timelineInfo.state != stored.state {
                print("Should update because state mismatch: current was \(timelineInfo.state.rawValue), but stored was \(stored.state.rawValue)")
                return true
            }
            
            
            if stored.endDate.timeIntervalSinceNow < 30*60 {
                print("Should update because time dif")
                return true
            }
            
            for item in stored.eventIDS {
                
                if let storeEvent = HLLEventSource.shared.findEventWithIdentifier(id: item.key) {
                    
                   // print("Found storeEvent")
                    
                    if storeEvent.infoIdentifier != item.value {
                        
                        
                        dif = true
                        
                    }
                    
                } else {
                    
                    print("storeEvent Not Found")
                    dif = true
                    
                }
                
                
            }
            
            return dif
            
        }
        
        print("Not updating because no timelines")
        return false
        
    }
    
    
}

enum TimelineDictKey: String {
    
    case eventsKey = "Events"
    case lastDateKey = "LastDate"
    case state = "State"
    case widgetDictKey = "LatestWidgetTimeline"
    
}

enum TimelineState: String {
    
    case normal = "normal"
    case noCalendarAccess = "noCalAccess"
    case notPurchased = "notPurchased"
    case notMigrated = "notMigrated"
    
}

enum TimelineType {
    
    case widget
    case complication
    
}

struct HLLTimelineInfo {
    
    let state: TimelineState
    let endDate: Date
    let eventIDS: [String:String]
    
    
}

