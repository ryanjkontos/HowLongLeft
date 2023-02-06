//
//  DetailSubmenuGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 8/3/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import SwiftUI


import Cocoa

class DetailSubmenuGenerator {
    

    func generateInfoMenuItemsFor(event: HLLEvent, isFollowingOccurence: Bool = false, isWithinFollowingOccurenceSubmenu: Bool = false, eventStatusItemFor: HLLEvent? = nil) -> [NSMenuItem] {
        
        //// print("Genning submenu")
      //  let isEventStatusItemMenu = event == eventStatusItemFor
        
        var items = [NSMenuItem]()
        
       /* let titleView = ProInfoMenuTitleViewController()
        let titleViewMenuItem = NSMenuItem()
        titleViewMenuItem.view = titleView.view
        items.append(titleViewMenuItem)
    
        items.append(.separator()) */
        
   
        
     let title = event.title.truncated(limit: 30, position: .middle, leader: "...")
        
        let topItem = NSMenuItem()
        
       
       /* let view = EventMenuInfoView.createFromNib()
        view.update(for: event)
        topItem.view = view
        topItem.target = self */
     
        
        items.append(topItem)
        
        switch event.completionStatus {
            
        case .upcoming:
    
        let startsInText = CountdownStringGenerator.generateCountdownTextFor(event: event).justCountdown

        topItem.title = "\(title) - In \(startsInText)"

            
        case .current:

            topItem.title = "On Now: \(title)"
            
        case .done:
            topItem.title = "Completed Event: \(title)"
        }
        
      //  items.append(topItem)
        
        if event.isAllDay {
            let allDayItem = NSMenuItem()
            allDayItem.title = "All-Day Event"
            items.append(allDayItem)
        }
       
       
        
        let infoData = HLLEventInfoItemGenerator(event)
        let infoArray = infoData.getInfoItems(for: [.completion, .location, .start, .end, .elapsed, .duration])
        
       items.append(NSMenuItem.separator())
        
        for item in infoArray {
            let menuItem = NSMenuItem()
            menuItem.title = item.combined()
            items.append(menuItem)
        }
        
        if HLLDefaults.general.showNextOccurItems, isWithinFollowingOccurenceSubmenu == false {
        
        var currentEvent: HLLEvent? = event
        var followingOccurences = [HLLEvent]()
        
            var counter = 0
            
            while currentEvent != nil, counter < 250 {
            
                counter += 1
                
           /* if let next = currentEvent?.followingOccurence {
            
                followingOccurences.append(next)
                currentEvent = next
                
            } else {
                currentEvent = nil
            } */
            
        }
            
        if followingOccurences.isEmpty == false {
        
            items.append(NSMenuItem.separator())
            let mainItem = HLLMenuItem()
            items.append(mainItem)
            
            DispatchQueue.global().async {
            
            if followingOccurences.count > 1, isFollowingOccurence, HLLDefaults.general.useNextOccurList  {
        
            let firstEvent = followingOccurences.first!

            
            mainItem.title = "More Following Occurences"
            
          
            
            let topMenuItem = NSMenuItem()
            topMenuItem.title = "Following Occurences: \(firstEvent.title)"
            
            let moreFollowingOccurencesSubmenu = HLLMenu()
                
            
                
            moreFollowingOccurencesSubmenu.addItem(topMenuItem)
            moreFollowingOccurencesSubmenu.addItem(NSMenuItem.separator())
                
            for nextOccurEvent in followingOccurences {
                    
                var text = nextOccurEvent.startDate.userFriendlyRelativeString()
            
                    text += ", \(nextOccurEvent.startDate.formattedTime())"
              
                let moreFollowingOccurencesSubmenuItem = HLLMenuItem()
                moreFollowingOccurencesSubmenuItem.title = text
                
                moreFollowingOccurencesSubmenuItem.submenuClosure = {
                    
                    return self.generateInfoSubmenuFor(event: nextOccurEvent, isFollowingOccurence: true, isWithinFollowingOccurenceSubmenu: true)
                    
                }
                
                moreFollowingOccurencesSubmenuItem.closure = { SelectedEventManager.shared.toggleSelection(for: nextOccurEvent)}
                
                if nextOccurEvent.isSelected {
                    moreFollowingOccurencesSubmenuItem.state = .on
                }
                
                moreFollowingOccurencesSubmenu.addItem(moreFollowingOccurencesSubmenuItem)
                
                }
                
                
                mainItem.submenu = moreFollowingOccurencesSubmenu
                
                    
            
        } else {
            
                if let nextOccur = event.followingOccurence, let title = infoData.getInfoItem(for: .nextOccurence)?.combined() {
             
                
               
                mainItem.title = title
                mainItem.submenuClosure = {
                
                    return self.generateInfoSubmenuFor(event: nextOccur, isFollowingOccurence: true)
                
                }
                
                mainItem.closure = { SelectedEventManager.shared.toggleSelection(for: nextOccur)}
                if nextOccur.isSelected {
                    mainItem.state = .on
                }
                
                
            }

        }
                
           
            }
            
            }
        }
        

        items.append(NSMenuItem.separator())
        
        var actionItems = [NSMenuItem]()
        
        
              if HLLStatusItemManager.shared.eventStatusItemEvents.contains(event) {
               
                      
                  let removeItem = NSMenuItem()
                  removeItem.title = "Remove Status Item..."
                  removeItem.target = MenuItemClosureHandler.shared
                  removeItem.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
                  
                  removeItem.representedObject = {
                      
                      DispatchQueue.main.async {
                      
                          HLLStatusItemManager.shared.removeEventStatusItem(with: event)
                          
                      }
                   
                  }
                        
               actionItems.append(removeItem)
                   
               }
        
            if HLLDefaults.general.pinnedEventIdentifiers.contains(event.persistentIdentifier) {
              
                   let unpinButton = NSMenuItem()
                  unpinButton.title = "Unpin"
                  unpinButton.target = MenuItemClosureHandler.shared
                  unpinButton.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
                  unpinButton.representedObject = {
        
                      DispatchQueue.global().async {
                          EventPinningManager.shared.unpinEvent(event)
                      }
                  
                      
                  }
                  
                  actionItems.append(unpinButton)
                          
              }
        
        let eventUIWindowButton = NSMenuItem()
                  eventUIWindowButton.title = "Open Countdown Window..."
                  eventUIWindowButton.target = EventUIWindowsManager.shared
                  eventUIWindowButton.action = #selector(EventUIWindowsManager.shared.eventUIButtonClicked(sender:))
                  DispatchQueue.main.async {
                  EventUIWindowsManager.shared.addItemWithEvent(item: eventUIWindowButton, event: event)
                  }
                  actionItems.append(eventUIWindowButton)
        
         
        
        if !HLLDefaults.general.pinnedEventIdentifiers.contains(event.persistentIdentifier), ProStatusManager.shared.isPro {
                                  
            let pinButton = NSMenuItem()
            pinButton.title = "Pin Event"
            pinButton.target = MenuItemClosureHandler.shared
            pinButton.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
            pinButton.representedObject = {
                                  
                DispatchQueue.global().async {
                    EventPinningManager.shared.pinEvent(event)
                 }
 
                }

                actionItems.append(pinButton)
                                  
            }
        
        if event.isUserHideable, ProStatusManager.shared.isPro {
        
        let hideButton = NSMenuItem()
        hideButton.title = "Hide Event"
        hideButton.target = MenuItemClosureHandler.shared
        hideButton.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
        
        hideButton.representedObject = {
            
            MacEventHidingManager.shared.hideEvent(event)
         
        }
                  
        actionItems.append(hideButton)
                          
        }

        
   
        if event.isNicknamed == false {
                        
            if ProStatusManager.shared.isPro {
            
                let addNicknameButton = HLLMenuItem()
                addNicknameButton.title = "Add Nickname"
                addNicknameButton.closure = {
                            
                DispatchQueue.global(qos: .userInteractive).async {
                    
                    let ui = MacNicknameUI()
                    ui.presentAddNicknameUI(for: event)
                                
                }
                            
        }
                        
                actionItems.append(addNicknameButton)
                
            }
                        
                    } else {
                        
                        let removeNicknameButton = HLLMenuItem()
                        removeNicknameButton.title = "Remove Nickname"
                        removeNicknameButton.closure = {
                            
                       //     NicknameManager.shared.setNickname(nil, for: event)
                            
                        }
                        
                        actionItems.append(removeNicknameButton)
                        
            
        }
          
        
        if HLLStatusItemManager.shared.eventStatusItemEvents.contains(event) == false, ProStatusManager.shared.isPro {
            
       let addStatusItemButton = NSMenuItem()
               addStatusItemButton.title = "Create Status Item"
               addStatusItemButton.target = MenuItemClosureHandler.shared
               addStatusItemButton.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
               addStatusItemButton.representedObject = {
                                         
                HLLStatusItemManager.shared.addEventStatusItem(with: event)
                                         
               }
        actionItems.append(addStatusItemButton)
            
        }
        
       
        
        if SelectedEventManager.shared.selectedEvent == event {
            
            let clearSelectionButton = HLLMenuItem()
            clearSelectionButton.title = "Clear Selection"
            clearSelectionButton.closure = {SelectedEventManager.shared.selectedEvent = nil}
            actionItems.append(clearSelectionButton)
            
        }
        

        
        if event.isAllDay {
            
            let hideAllDayEventsButton = NSMenuItem()
            hideAllDayEventsButton.title = "Hide All-Day Events"
            hideAllDayEventsButton.target = MenuItemClosureHandler.shared
            hideAllDayEventsButton.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
            hideAllDayEventsButton.representedObject = {
                
                HLLDefaults.general.showAllDay = false
                HLLEventSource.shared.updateEventsAsync()
                
            }
            actionItems.append(hideAllDayEventsButton)
            
        }
        
        if let calendar = event.calendar, HLLDefaults.calendar.enabledCalendars.contains(calendar.calendarIdentifier) {
            
            let calendarButton = HLLMenuItem()
            calendarButton.title = "Disable \"\(calendar.title)\""
            calendarButton.closure = {
                
                DispatchQueue.main.async {
                
                    CalendarDefaultsModifier.shared.toggle(calendar: calendar)
                    HLLEventSource.shared.updateEventsAsync()
                    
                }
                
            }
            
            actionItems.append(calendarButton)
            
            let allButButton = HLLMenuItem()
            allButButton.title = "Only Use \"\(calendar.title)\""
            allButButton.closure = {
                
                DispatchQueue.main.async {
                       
                        CalendarDefaultsModifier.shared.setAllDisabled()
                        CalendarDefaultsModifier.shared.setEnabled(calendar: calendar)
                        HLLEventSource.shared.updateEventsAsync()
       
                }
                
            }
            
            actionItems.append(allButButton)
            
            
            
        }

      /*  if let location = event.location, EventLocationIndexer.shared.index[location] != nil {
            
            let locationButton = NSMenuItem()
            locationButton.title = "Show Location In Maps..."
            locationButton.representedObject = event
            locationButton.target = MapMenuItemHandler.shared
            locationButton.action = #selector(MapMenuItemHandler.shared.openMapsFor(sender:))
            actionItems.append(locationButton)
            
            
        } */
        
    
        
        if HLLDefaults.general.showNextOccurItems == true, isFollowingOccurence == true {
            
            let hideNextOccurButton = NSMenuItem()
            hideNextOccurButton.title = "Hide Following Occurences"
            hideNextOccurButton.target = MenuItemClosureHandler.shared
            hideNextOccurButton.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
            hideNextOccurButton.representedObject = {
                           
                HLLDefaults.general.showNextOccurItems = false
                HLLEventSource.shared.updateEventsAsync()
                           
            }
            actionItems.append(hideNextOccurButton)
            
            
        }

        
        if actionItems.count > 2 {
            
            let firstItem = actionItems.remove(at: 0)
            items.append(firstItem)
          //  let secondItem = actionItems.remove(at: 1)
            //items.append(secondItem)

            let actionsSubmenu = NSMenu()
            
            for item in actionItems {
                
                actionsSubmenu.addItem(item)
                
            }
            
            let moreActionsMenuItem = NSMenuItem()
            moreActionsMenuItem.title = "More..."
            moreActionsMenuItem.submenu = actionsSubmenu
            
            items.append(moreActionsMenuItem)
            
            
        } else {
            
            for item in actionItems {
                
                items.append(item)
            }
            
        }
            
        return items
        
    }
    
    func generateInfoSubmenuFor(event: HLLEvent, isFollowingOccurence: Bool = false, isWithinFollowingOccurenceSubmenu: Bool = false ) -> NSMenu {
        
        let items = generateInfoMenuItemsFor(event: event, isFollowingOccurence: isFollowingOccurence, isWithinFollowingOccurenceSubmenu: isWithinFollowingOccurenceSubmenu)
        
        let returnMenu = HLLMenu()
        
        for item in items {
            
            returnMenu.addItem(item)
            
        }
        
        return returnMenu
        
    }
    
    
}
