//
//  EventUIWindowsManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class EventUIWindowsManager: NSObject, NSWindowDelegate {
    
    static var shared = EventUIWindowsManager()
    
    var eventUIWindowControllers = [String:NSWindowController]()
    var eventUIStoryboard = NSStoryboard(name: "EventUIStoryboard", bundle: nil)
    var existingEventUIButtons = [NSMenuItem:HLLEvent]()
    
    func removeItems() {
        
        existingEventUIButtons.removeAll()
        
    }
    
    func addItemWithEvent(item: NSMenuItem, event: HLLEvent) {
        
        existingEventUIButtons[item] = event
        
    }
    
    
    
    @objc func eventUIButtonClicked(sender: NSMenuItem) {
        
        if let event = existingEventUIButtons[sender] {
            
          launchWindowFor(event: event)
            
        }
        
    }
    
    func launchWindowFor(event: HLLEvent) {
        
        var id: String
        
        if let ekID = event.EKEvent?.eventIdentifier {
            
            id = ekID
            
        } else {
            
            id = event.persistentIdentifier
            
        }
        
        
        if let window = eventUIWindowControllers[id] {
            
            window.window?.delegate = self
            NSApp.setActivationPolicy(.regular)
            window.showWindow(self)
            
            
        } else {
            
            let vc = self.eventUIStoryboard.instantiateController(withIdentifier: "MainUI") as? NSWindowController
            vc?.window?.delegate = self
            
            
            (vc!.contentViewController?.children.first as! EventUITabViewController).event = event
            
            eventUIWindowControllers[id] = vc
            
            if let window = eventUIWindowControllers[id] {
                
                NSApp.setActivationPolicy(.regular)
                window.window?.center()
                
                window.showWindow(self)
                window.window?.delegate = self
               
                
                
            }
            
        }
        
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        
        for keyValue in eventUIWindowControllers {
            
            if keyValue.value == sender.windowController! {
                
                
                eventUIWindowControllers.removeValue(forKey: keyValue.key)
                
            }
            
        }
        
        return true
        
    }
    
    let floatButtonID = "Float Countdown Window"
    
    func deleteFloatButton() {
        
        if let menu = NSApp.windowsMenu {
            
            for item in menu.items {
                
                if item.title == floatButtonID {
                    menu.removeItem(item)
                }
                
            }
            
           
            
        }
        
    }
    
    @objc func floatButtonClicked() {
        
        for windowController in self.eventUIWindowControllers.values {
            
            guard let window = windowController.window else { continue }
            
            if window.isMainWindow {
                
                if window.level == .floating {
                    window.level = .normal
                } else {
                    window.level = .floating
                }
                
               
                
            }
            
        }
        
        updateFloatButton()
        
    }
    
    func mainWindowIsFloating() -> Bool {
        
        for windowController in self.eventUIWindowControllers.values {
            
            guard let window = windowController.window else { continue }
            
            if window.isMainWindow {
                
                if window.level == .floating {
                    return true
                } else {
                   return false
                }
                
               
                
            }
            
        }
        
        return false
        
    }
    
    func updateFloatButton() {
        
        deleteFloatButton()
        let item = NSMenuItem(title: floatButtonID, action: #selector(floatButtonClicked), keyEquivalent: "")
            
            if mainWindowIsFloating() {
                item.state = .on
            } else {
                item.state = .off
            }
            
        
        NSApp.windowsMenu?.insertItem(item, at: 0)
        
    }

    func windowDidBecomeMain(_ notification: Notification) {
        
        
      updateFloatButton()
        
        
    }
    
    
    func windowDidResignMain(_ notification: Notification) {
        
        deleteFloatButton()

        
    }
    
}


