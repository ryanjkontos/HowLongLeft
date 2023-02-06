//
//  NSMenuItemMaker.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

extension NSMenuItem {
    
    class func makeItem(title: String, submenu: NSMenu? = nil, state: NSControl.StateValue = NSControl.StateValue.off, action: Selector? = nil, target: AnyObject? = nil) -> NSMenuItem {
        
        let item = NSMenuItem()
        item.title = title
        item.submenu = submenu
        item.state = state
        
        if action != nil {
        item.action = action
        }
        
        if target != nil {
        item.target = target
        }
        
        if submenu != nil {
        item.isEnabled = true
        }
        
        return item
        
    }
    
}


extension NSMenu {
    
    class func makeMenu(items: [NSMenuItem]) -> NSMenu {
        
        let menu = NSMenu()
        for item in items {
            
            item.isEnabled = true
            
            menu.addItem(item) }
        return menu
    }
    
    
}
