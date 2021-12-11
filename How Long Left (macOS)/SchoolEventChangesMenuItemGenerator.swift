//
//  SchoolEventChangesMenuItemGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 19/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class SchoolEventChangesMenuItemGenerator {
    
    var changedEvents = [HLLEvent]()
    
    init(events: [HLLEvent]) {
        
        self.changedEvents = events.filter({ event in
            return event.roomChange != nil || event.teacherChange != nil
        })
        
    }
    
    let eventSubmenuGenerator = DetailSubmenuGenerator()
    
    func generateSchoolEventChangesMenuItem() -> NSMenuItem? {
        
        let events = self.changedEvents
        
        if changedEvents.isEmpty {
            return nil
        }
        
        let count = changedEvents.count
        let relativeString = events.first!.startDate.userFriendlyRelativeString()
                        
        var changesText = "Change"
        if count != 1 {
            changesText += "s"
        }
                        
        let menuTitle = "\(count) \(changesText) \(relativeString)"
               
        let item = NSMenuItem()
        item.title = menuTitle
        if events.isEmpty == false {
        item.submenu = NSMenu()
        }
               
        return item
        
    }
    
    func generateSchoolEventChangesSubmenu() -> NSMenu? {
    
        let events = self.changedEvents
               
        if changedEvents.isEmpty {
            return nil
        }
               
        let relativeString = events.first!.startDate.userFriendlyRelativeString()
        
        let submenu = NSMenu()
        
        let headerMenuItem = NSMenuItem()
        headerMenuItem.title = "Changes \(relativeString):"
        submenu.addItem(headerMenuItem)
        
        for event in changedEvents {
            
            let eventMenuItem = HLLMenuItem()
            
            var titleString = event.title
            
            if let room = event.roomChange?.replacingOccurrences(of: ":", with: "", options: NSString.CompareOptions.literal, range:nil) {
                
                titleString += " (Moved to \(room)"
                
                if let teacher = event.teacherChange {
                    
                    titleString += ", with \(teacher)"
                    
                }
                
                titleString += ")"
                
            } else if let teacher = event.teacherChange {
                
                titleString += " (Sub: \(teacher))"
            }
            
            if event.isSelected {
                eventMenuItem.state = .on
            }
            
            eventMenuItem.title = titleString
            eventMenuItem.submenu = NSMenu()
            
            DispatchQueue.global(qos: .default).async {
                
                let submenu = self.eventSubmenuGenerator.generateInfoSubmenuFor(event: event)
                
                DispatchQueue.main.async {
                  eventMenuItem.submenu = submenu
                }
                
            }
            
            eventMenuItem.closure = { SelectedEventManager.shared.toggleSelection(for: event) }
            
            submenu.addItem(eventMenuItem)
            
        }
        
        return submenu
    
    }
    
    
}
