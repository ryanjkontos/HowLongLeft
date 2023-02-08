//
//  HLLTimelineConfiguration.swift
//  How Long Left
//
//  Created by Ryan Kontos on 7/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation

// MARK: WidgetGroup

struct HLLTimelineConfiguration: Equatable, Hashable, Codable, Identifiable {

    var id: String { String(creationDate.timeIntervalSinceReferenceDate) }
    
    var name: String = ""
    
    var creationDate: Date = Date()
    
    var groupType: GroupType = .customGroup
    
    var useAllCalendars = true
    
    var showUpcoming = true
    
    var showCurrent = true
    
    var alwaysShowPinned = true
    
    var enabledCalendarIDs = Set<String>()
    
    var sortMode: TimelineSortMode = .chronological
    
    enum GroupType: Codable {
        
        case defaultGroup
        case customGroup
        
    }
    
    static func newCustomConfig() -> HLLTimelineConfiguration {
        
        return HLLTimelineConfiguration(creationDate: Date(), groupType: .customGroup)
        
    }
    

    
}

enum TimelineSortMode: CaseIterable, Identifiable, Codable {
    
    var id: TimelineSortMode { return self }
    
    case chronological
    case currentFirst
    case upcomingFirst
    
    var name: String {
        switch self {
        case .chronological:
            return "Soonest to Start or End"
        case .currentFirst:
            return "In Progress Events"
        case .upcomingFirst:
            return "Upcoming Events"
        }
    }
    
    var functionDescription: String {
        switch self {
        case .chronological:
            return "Display the next event to either start or end."
        case .currentFirst:
            return "Only display the next event to start if there are no events currently in progress."
        case .upcomingFirst:
            return "Only display an in progress event if there are no events upcoming."
        }
        
    }
    
    
}
