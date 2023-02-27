//
//  MenuTopShelfGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class MenuTopShelfGenerator {
    
    let eventItemGen = EventMenuItemGenerator()
    let submenuGen = DetailSubmenuGenerator()
    let upcomingSectionGen = UpcomingSoonMenuGenerator()
    let upcomingWeekGen = UpcomingWeekMenuGenerator()
   
    var featuredItems = [NSMenuItem]()
    let quickMenuGen = QuickPreferencesSubmenuGenerator()
    
    func generateMainMenu(featured: [HLLEvent], upcoming: [DateOfEvents], moreUpcoming: [DateOfEvents], pinned: [HLLEvent]) -> [NSMenuItem] {
        
        var items = [NSMenuItem]()
        
        var filteredFeatured = featured
        
        if pinned.isEmpty == false {
                   
                   
                   
                   let pinnedTitleItem = NSMenuItem()
                   pinnedTitleItem.title = "Pinned:"
                   items.append(pinnedTitleItem)
                   
                   for event in pinned {
                       
                       let item = self.eventItemGen.makeCountdownMenuItem(for: event)
                       items.append(item)
                    
                    filteredFeatured.removeAll(where: {$0.persistentIdentifier == event.persistentIdentifier})
                       
                   }
            
            items.append(NSMenuItem.separator())
                   
               }
    
        
        let upcomingWillBeShown = HLLDefaults.menu.listUpcoming == true && HLLDefaults.menu.topLevelUpcoming == true
        
       
        
        let topLevelUpcoming = upcomingWillBeShown
        
        EventUIWindowsManager.shared.removeItems()

        if let selected = SelectedEventManager.shared.selectedEvent {
          
        var show = true
            
            if !filteredFeatured.contains(selected), !pinned.contains(selected) {
                
                for date in upcoming {
                
                if date.events.contains(selected) {
                    
                    if upcomingWillBeShown == true {
                        
                        show = false
                        
                    }
                    
                }
                    
                }
                    
                
                
            } else {
                
                show = false
                
            }
         
        if show == true {
            
        let item = eventItemGen.makeCountdownMenuItem(for: selected)
        items.append(item)
        items.append(NSMenuItem.separator())
                
        }
            
            
        }
 
        
        if filteredFeatured.isEmpty == false {
                    
            
            for event in filteredFeatured {
                
                let item = eventItemGen.makeCountdownMenuItem(for: event)
                item.representedObject = event
                items.append(item)
                
            }
            
        }
        
        if topLevelUpcoming {
            
            items.append(NSMenuItem.separator())
            items.append(contentsOf: upcomingSectionGen.generateUpcomingSoonMenuItems(for: upcoming))
        
        } else if HLLDefaults.menu.listUpcoming == true {
           
            items.append(NSMenuItem.separator())
            items.append(upcomingSectionGen.generateUpcomingSoonMenuItemWithSubmenu(for: upcoming))
            
        }
        
        if HLLDefaults.general.showUpcomingWeekMenu, moreUpcoming.isEmpty == false {
        
        items.append(NSMenuItem.separator())
        
        let moreUpcomingMenuItem = HLLMenuItem()
        moreUpcomingMenuItem.title = "More Upcoming"
            
            if HLLDefaults.menu.listUpcoming == false {
                moreUpcomingMenuItem.title = "Upcoming Events"
            }
            
        moreUpcomingMenuItem.submenu = NSMenu()
        
        items.append(moreUpcomingMenuItem)
        
        DispatchQueue.global().async {
            
            let submenu = self.upcomingWeekGen.generateUpcomingWeekMenuItem(for: moreUpcoming)
            
            DispatchQueue.main.async {
                moreUpcomingMenuItem.submenu = submenu
            }
            
        }
        
        }
        
       
        
        if CalendarDefaultsModifier.shared.getEnabledCalendars().isEmpty {
                   
            items.removeAll()
            let item = NSMenuItem()
            item.title = "You haven't selected any calendars to use with How Long Left..."
            items.append(item)
            let item2 = NSMenuItem()
            item2.title = "No events will be found until you fix this in Preferences."
            items.append(item2)
                   
        }
        
        if CalendarReader.shared.calendarAccess == .Denied {
                   
            items.removeAll()
            let item = NSMenuItem()
            item.title = "How Long Left needs calendar access to show your events."
            items.append(item)
            let item2 = NSMenuItem()
            item2.title = "Fix in System Preferences..."
            
            item2.target = MenuItemClosureHandler.shared
            item2.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
            item2.representedObject = {
                
                DispatchQueue.main.async {
                    
                    if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars") {
                        NSWorkspace.shared.open(url)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NSWorkspace.shared.launchApplication("System Preferences")
                    }
                    
                }
                
                
            }
            
            items.append(item2)
                   
        }
        
        items.append(NSMenuItem.separator())
        

        
        items.append(NSMenuItem.separator())
        
      //  let quickMenu = quickMenuGen.getQuickPreferencesSubmenu()
        
        
        
        let preferencesMenuItem = NSMenuItem()
        preferencesMenuItem.setAccessibilityTitle("Open How Long Left Preferences...")
        preferencesMenuItem.title = "Preferences..."
        preferencesMenuItem.keyEquivalent = ","
        preferencesMenuItem.keyEquivalentModifierMask = .command
        preferencesMenuItem.target = PreferencesWindowManager.shared
        preferencesMenuItem.action = #selector(PreferencesWindowManager.shared.objcLaunchPreferences)
       // preferencesMenuItem.submenu = quickMenu
        items.append(preferencesMenuItem)
        
        let quitMenuItem = NSMenuItem()
        quitMenuItem.title = "Quit How Long Left"
        quitMenuItem.keyEquivalent = "q"
        quitMenuItem.keyEquivalentModifierMask = .command
        quitMenuItem.target = TerminationHandler.shared
        quitMenuItem.action = #selector(TerminationHandler.shared.terminateApp)
        items.append(quitMenuItem)

        
        if NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.option) {
            
            items.append(NSMenuItem.separator())
            let menuItem = NSMenuItem()
            menuItem.title = "How Long Left \(Version.currentVersion) (\(Version.buildVersion))"
            items.append(menuItem)
            
            let aboutItem = HLLMenuItem()
            aboutItem.title = "About..."
            aboutItem.closure = {AboutWindowManager.shared.showProOnboarding()}
            items.append(aboutItem)
            
        }
        
        return items
        
    }
    
    @objc func updateFeaturedItems() {
        
        DispatchQueue.main.async {
        
        let items = self.featuredItems
        
        for item in items {
            
            if let event = item.representedObject as? HLLEvent, self.featuredItems.contains(item) {
                
                let tempItem = self.eventItemGen.makeCountdownMenuItem(for: event)
                item.title = tempItem.title
                
            }
            
        }
            
        }
        
    }
    
}

/*struct DummyHLLWidgetEntry  {
    internal init(date: Date, event: HLLEvent?, events: [HLLEvent]) {
        self.date = date
        self.event = event
        self.events = events
        
        if let uEvent = event {
        
            // print("Init HLLWidgetEntry with \(uEvent.title) at \(date.formattedDate())")
            
        } else {
            
            // print("Init HLLWidgetEntry with no event at \(date.formattedDate())")
        }
        
    }
    
    
    
    
    let date: Date
    let event: HLLEvent?
    let events: [HLLEvent]
}
*/
