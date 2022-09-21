//
//  MagdalenePrompts.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 19/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

/*
import AppKit

class MagdalenePrompts {
   
    let version = Version()
    let showChangesPrompt = false
    
    func presentMagdaleneChangesPrompt() {
        
        if showChangesPrompt == true {

            DispatchQueue.main.async {
            
            let alert: NSAlert = NSAlert()
            alert.window.title = "How Long Left \(Version.currentVersion)"
            alert.messageText = "New in Magdalene Mode:"
            alert.informativeText = """
                - Added the option to show a countdown to the HSC. You can enable it in Magdalene Preferences.
                
            """
                    
            alert.alertStyle = NSAlert.Style.informational
            alert.addButton(withTitle: "OK")
            alert.window.collectionBehavior = .canJoinAllSpaces
            alert.window.level = .floating
            alert.runModal()
            NSApp.activate(ignoringOtherApps: true)
            

            }
        }
 
    }
    
    func presentShowStudyAsSportPrompt() {
        
                
                DispatchQueue.main.async {
                    NSApp.activate(ignoringOtherApps: true)
                }
            
                let alert: NSAlert = NSAlert()
                alert.window.title = "How Long Left"
                alert.messageText = "Would you like How Long Left to show your Tuesday sport period as \"Study\"?"
                alert.informativeText = "This is useful if you do study during sport."
            
                alert.alertStyle = NSAlert.Style.informational
                
                
                alert.addButton(withTitle: "Yes")
                alert.addButton(withTitle: "No")
                alert.window.collectionBehavior = .canJoinAllSpaces
                alert.window.level = .floating
                
                let button = alert.runModal()
                
                
                if button == NSApplication.ModalResponse.alertFirstButtonReturn {
                    
                    
                    HLLEventSource.shared.updateEventPool()
                   
                }
                
    }
    
    func presentSchoolHolidaysPrompt() {
            
            NSApp.activate(ignoringOtherApps: true)
            let alert: NSAlert = NSAlert()
            alert.window.title = "How Long Left \(Version.currentVersion)"
            alert.messageText = "School is done for the term."
            alert.informativeText = """
            How Long Left will count down to the start of next term. You can disable this in Magdalene preferences.
            
            """
            
            alert.alertStyle = NSAlert.Style.informational
            alert.addButton(withTitle: "OK")
            alert.window.collectionBehavior = .canJoinAllSpaces
            alert.window.level = .floating
            NSApp.activate(ignoringOtherApps: true)
            alert.runModal()
            
        
    }
}
*/
