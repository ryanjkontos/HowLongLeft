//
//  PrimaryEventManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/7/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa

class PrimaryEventManager {
    
    static var shared = PrimaryEventManager()
    
    static var primaryEvent: HLLEvent?
    
    var currentEventItemEvents = [NSMenuItem:HLLEvent]()
    
    func removeItems() {
        
        currentEventItemEvents.removeAll()
        
    }
    
    func addItemWithEvent(item: NSMenuItem, event: HLLEvent) {
        
        currentEventItemEvents[item] = event
        
    }
    
    @objc func currentEventMenuItemClicked(sender: NSMenuItem) {
        
        if sender.state == .on {
            
            PrimaryEventManager.primaryEvent = nil
            
            
        } else {
            
            if let eventForSender = currentEventItemEvents[sender], let selected = PrimaryEventManager.primaryEvent {
                
                if selected == eventForSender {
                    
                    sender.state = .off
                    
                } else {
                    
                    PrimaryEventManager.primaryEvent = self.currentEventItemEvents[sender]
                    
                }
                
                
            } else {
                
                PrimaryEventManager.primaryEvent = self.currentEventItemEvents[sender]
                
            }
            
        }
        
        Main.shared?.mainRunLoop()
        
    }

    
}
