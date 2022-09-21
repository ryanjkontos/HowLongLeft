//
//  MacNicknameUI.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class MacNicknameUI {
    
    
    func presentAddNicknameUI(for event: HLLEvent) {
        
        DispatchQueue.main.async {
            
             NSApp.activate(ignoringOtherApps: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            let msg = NSAlert()
            msg.addButton(withTitle: "OK")
            msg.addButton(withTitle: "Cancel")
            msg.messageText = "Enter nickname for \(event.originalTitle)"
            msg.informativeText = "How Long Left will show this event's nickname instead of its actual title. All events with this title will be affected."

                msg.window.level = .floating
                msg.window.collectionBehavior = [.moveToActiveSpace]
                
            let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
            txt.placeholderString = "Nickname"
            txt.stringValue = ""

            msg.accessoryView = txt
            msg.layout()
         
            txt.window?.initialFirstResponder = txt
            
        DispatchQueue.main.async {
            
           
              
            let response: NSApplication.ModalResponse = msg.runModal()
           
              
                
        if (response == NSApplication.ModalResponse.alertFirstButtonReturn) {
               
            //NicknameManager.shared.setNickname(txt.stringValue, for: event)
            
        }
                
            }
            
          
            }
           
            
        }
  
    }
    
}
