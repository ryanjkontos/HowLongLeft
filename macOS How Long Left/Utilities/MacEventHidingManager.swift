//
//  MacEventHidingManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class MacEventHidingManager {
    
    static var shared = MacEventHidingManager()
    
    func hideEvent(_ event: HLLEvent) {
        
        var hideEvent = true
        
        if HLLDefaults.general.askToHide {
        
        let confirmationEvent = NSAlert()
        confirmationEvent.showsSuppressionButton = true
        confirmationEvent.suppressionButton!.title = "Don't ask again"
        
            confirmationEvent.messageText = "Hide \(event.title)?"
        confirmationEvent.informativeText = "You'll be able to unhide it in Preferences."
        confirmationEvent.addButton(withTitle: "OK")
        confirmationEvent.addButton(withTitle: "Cancel")
        
            NSApp.activate(ignoringOtherApps: true)
            
            if confirmationEvent.runModal() == .cancel {
                hideEvent = false
            }

        
        if confirmationEvent.suppressionButton!.state == .on {
            HLLDefaults.general.askToHide = false
        }
            
        }

        if hideEvent {
        
            HLLStoredEventManager.shared.hideEvent(event)
            
        }
        
        
    }
    
}
