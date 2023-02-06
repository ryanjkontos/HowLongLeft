//
//  UpcomingWeekMenuGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class UpcomingWeekMenuGenerator {
    
    let eventListGen = EventListMenuGenerator()
    
    func generateUpcomingWeekMenuItem(for days: [DateOfEvents]) -> NSMenu {
        
        let submenu = HLLMenu()
        
        var items = [DateOfEvents]()
        
        if HLLDefaults.menu.listUpcoming {
        
        for day in days {
            
            
            if day.date.startOfDay() != CurrentDateFetcher.currentDate.startOfDay() {
                items.append(day)
            }
            
            
        }
            
        } else {
            items = days
        }
        
        for dayOfEvents in items {
            
            let item = HLLMenuItem()
            
            for event in dayOfEvents.events {
                
                if SelectedEventManager.shared.selectedEvent == event {
                    
                    item.state = .mixed
                    
                }
                
            }
            
            let count = dayOfEvents.events.count
            
            var eventsText = "event"
            if count != 1 {
                eventsText += "s"
            }
            
            item.title = "\(dayOfEvents.date.getDayOfWeekName(returnTodayIfToday: true)) (\(count) \(eventsText))"
            
            item.submenuClosure = {
                self.eventListGen.generateEventListMenu(for: dayOfEvents.events, includeDayHeader: false)
                
            }

            
            if dayOfEvents.events.isEmpty {
                
                item.isEnabled = false
                
            } else {
                
                item.isEnabled = true
                
            }
            
            submenu.addItem(item)
            
            if dayOfEvents.date.startOfDay() == CurrentDateFetcher.currentDate.startOfDay() {
                
                submenu.addItem(NSMenuItem.separator())
                
            }
            
        }
        
        return submenu
        
    }
    
}
