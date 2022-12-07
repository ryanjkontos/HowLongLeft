//
//  MainMenuGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 7/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa


class MainMenuGenerator {
    
    let topShelfGen = MenuTopShelfGenerator()
    let upcomingWeekGen = UpcomingWeekMenuGenerator()
    
    func generateMenu() -> [NSMenuItem] {
        
        let featured = HLLEventSource.shared.getTopShelfEvents()
        
        //let upcoming = HLLEventSource.shared.getUpcomingEventsFromNextDayWithEvents()
        let moreUpcoming = HLLEventSource.shared.getArraysOfUpcomingEventsForNextSevenDays(returnEmptyItems: true, allowToday: true)
            
        let filtered = moreUpcoming.filter {$0.events.isEmpty == false}
        
        let upcoming = Array(filtered.prefix(1))
        
        let pinned = HLLEventSource.shared.getPinnedEventsFromevents()
        
        let menuItems = self.topShelfGen.generateMainMenu(featured: featured, upcoming: upcoming, moreUpcoming: moreUpcoming, pinned: pinned)
        
        return menuItems
        
    }
    
    
}
