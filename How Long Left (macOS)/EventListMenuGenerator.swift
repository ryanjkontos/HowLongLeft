//
//  EventListMenuGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 14/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class EventListMenuGenerator {
    
    let eventItemGen = EventMenuItemGenerator()
    
    func generateEventListMenu(for events: [HLLEvent], includeDayHeader: Bool, isFollowingOccurence: Bool = false) -> NSMenu {
        
        var dateOfLastEvent = CurrentDateFetcher.currentDate
        
        var items = [NSMenuItem]()
        
        var previous: HLLEvent?
        
        for event in events {
            
            if let prev = previous, prev.completionStatus == .done, event.completionStatus != .done {
                
                items.append(NSMenuItem.separator())
                
            }
            
            previous = event
            
            if includeDayHeader == true {
            
            if dateOfLastEvent != event.startDate.startOfDay() {
                
                var title = event.startDate.userFriendlyRelativeString()
                
                if event.startDate.startOfDay() == CurrentDateFetcher.currentDate.startOfDay() {
                    
                    title = "Upcoming \(title)"
                    
                }
                
                let menuItem = NSMenuItem.makeItem(title: "\(title):")
                items.append(menuItem)
                
                }
                
            }
            
            let menuItem = eventItemGen.makeEventInfoMenuItem(for: event, needsDateContextInTitle: true, isFollowingOccurence: isFollowingOccurence)
            items.append(menuItem)
            
            dateOfLastEvent = event.startDate.startOfDay()
            
        }
        
        return NSMenu.makeMenu(items: items)
    }
    
    
}
