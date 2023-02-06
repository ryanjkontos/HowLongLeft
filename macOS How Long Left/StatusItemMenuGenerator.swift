//
//  StatusItemMenuGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan on 29/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class StatusItemMenuGenerator {
    
    let mainMenuGenerator = MainMenuGenerator()
    let submenuGenerator = DetailSubmenuGenerator()
    
    func getStatusItemMenu(for configuration: HLLStatusItemConfiguration) -> [NSMenuItem] {
        
        switch configuration.type {
            
        case .main:
            
            return mainMenuGenerator.generateMenu()
            
        case .event:
            
            let event = configuration.eventRetriver.retrieveEvent()!
            let menu = submenuGenerator.generateInfoMenuItemsFor(event: event)
            
    
            
            return menu
            
        }
        
    }
    
    
}
