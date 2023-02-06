//
//  UpcomingSoonMenuGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class UpcomingSoonMenuGenerator {
    
    let eventItemGen = EventMenuItemGenerator()
    let upcomingStringGen = UpcomingEventStringGenerator()
    
    func generateUpcomingSoonMenuItems(for dates: [DateOfEvents]) -> [NSMenuItem] {
        
        var items = [NSMenuItem]()
        
        for day in dates {
        
        if day.events.isEmpty == false {
            
            var dateOfLastEvent = CurrentDateFetcher.currentDate
            
            items.append(NSMenuItem.separator())
            
            for event in day.events {
                
                if dateOfLastEvent != event.startDate.startOfDay() {
                    
                    let title = "Upcoming \(event.startDate.userFriendlyRelativeString())"
                    items.append(NSMenuItem.makeItem(title: title))
                    
                }
                
                items.append(eventItemGen.makeEventInfoMenuItem(for: event, needsDateContextInTitle: true))
                dateOfLastEvent = event.startDate.startOfDay()
                
            }
            
        }
            
        }
        
        if items.isEmpty {
            
          return [eventItemGen.makeNoUpcomingMenuItem()]
            
        }
        
        return items
        
    }
    
    func generateUpcomingSoonMenuItemWithSubmenu(for dates: [DateOfEvents]) -> NSMenuItem {
        
        var menuItem: NSMenuItem?
    
        if dates.indices.contains(0) {
        
        let events = dates[0].events
            
        if !events.isEmpty {
            
            menuItem = NSMenuItem()
            
            for event in events {
                
                if SelectedEventManager.shared.selectedEvent == event {
                    
                    menuItem!.state = .mixed
                    
                }
                
            }
            
          
            
            let menuItemTitle = "Upcoming \(events.first!.startDate.userFriendlyRelativeString())"
            let submenu = NSMenu.makeMenu(items: generateUpcomingSoonMenuItems(for: [dates[0]]))
            menuItem = NSMenuItem.makeItem(title: menuItemTitle, submenu: submenu, state: .off)
            
        }
            
        }
        
        if menuItem == nil {
           
            menuItem = eventItemGen.makeNoUpcomingMenuItem()
            menuItem!.submenu = NSMenu()
            menuItem!.isEnabled = false
            
        }
        
        return menuItem!
    }
    
}
