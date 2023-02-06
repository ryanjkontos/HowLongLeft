//
//  QuickPreferencesSubmenuGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 18/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class QuickPreferencesSubmenuGenerator {
    
    func getQuickPreferencesSubmenu() -> NSMenu {
        
        let menu = NSMenu()
        
        let titleItem = NSMenuItem()
        titleItem.title = "Quick Preferences:"
        menu.addItem(titleItem)
        
        var setTo = true
        var statusItemTitle = "Disable Status Item"
        
        if HLLDefaults.statusItem.disabled {
            
            setTo = false
            statusItemTitle = "Enable Status Item"
            
        }
        
        let statusItemButton = NSMenuItem()
        statusItemButton.title = statusItemTitle
        statusItemButton.target = MenuItemClosureHandler.shared
        statusItemButton.action = #selector(MenuItemClosureHandler.shared.runClosureFor(sender:))
        
        statusItemButton.representedObject = {
                    
            HLLDefaults.statusItem.disabled = setTo
        
        }
        
        menu.addItem(statusItemButton)
        
        return menu
    
}

}
