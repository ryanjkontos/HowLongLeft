//
//  EventMenuItemGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 14/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class EventMenuItemGenerator {
    
    let eventSubmenuGenerator = DetailSubmenuGenerator()
    
    func makeEventInfoMenuItem(for event: HLLEvent, needsDateContextInTitle: Bool, isFollowingOccurence: Bool = false) -> NSMenuItem {
        
        let title = event.title.truncated(limit: 30, position: .middle, leader: "...")
        
        var text = title
        
        if let location = event.location?.truncated(limit: 30, position: .middle, leader: "...") {
            
            var locationString = location
            
            if location.contains(text: "Room: ") {
                
                let justRoom = location.components(separatedBy: "Room: ").last!
                locationString = "Room: \(justRoom)"
                
                
            }
            
            text += " (\(locationString))"

        }
        
        if event.isAllDay == true {
            
            text = "\(title) (All-Day)"
            
        }
        
        if isFollowingOccurence {
            
            var relativeDateText = event.startDate.userFriendlyRelativeString()
            
        
            
            text = "\(title) (\(relativeDateText))"
        }
        

        let item = HLLMenuItem()
        
        item.title = text
        item.state = .off
        item.submenu = NSMenu()
        

            DispatchQueue.main.async {
            
            let submenu = self.eventSubmenuGenerator.generateInfoSubmenuFor(event: event, isWithinFollowingOccurenceSubmenu: isFollowingOccurence)
            
            
              item.submenu = submenu
            }
            
        
        
        if event.completionStatus != .done {
            
            item.closure = { SelectedEventManager.shared.toggleSelection(for: event) }
            
        }
        
        item.closure = { SelectedEventManager.shared.toggleSelection(for: event) }
        
        if SelectedEventManager.shared.selectedEvent == event {
            
            item.state = .on
        }
        
        return item
        
    }
    
    func makeCountdownMenuItem(for event: HLLEvent) -> NSMenuItem {
        
        let title = countdownStringGenerator.generateCountdownTextFor(event: event, showEndTime: false)
        
        let item = HLLMenuItem()
        
        item.title = title.combined()
        
        if event.completionStatus == .done {
            item.title = "\(event.title.truncated(limit: 25, position: .middle, leader: "...")) is done"
        }
        
        item.state = .off
        
        item.submenu = NSMenu()
        

            DispatchQueue.main.async {
            
            let submenu = self.eventSubmenuGenerator.generateInfoSubmenuFor(event: event)
                
              item.submenu = submenu
            }
            
        
        
        if event.isSelected {
            item.state = .on
        }
            
        item.closure = {
            
            SelectedEventManager.shared.toggleSelection(for: event)
            
        }
        
        return item
        
    }
    
    func makeNoEventOnMenuItem() -> NSMenuItem {
        
        return NSMenuItem.makeItem(title: "No Current Events")
        
    }
    
    func makeNoUpcomingMenuItem() -> NSMenuItem {
        
        return NSMenuItem.makeItem(title: "No Upcoming Events")
        
    }
    
    
    
}
