//
//  AboutWindowManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class AboutWindowManager: NSObject, NSWindowDelegate {
    
    static var shared = AboutWindowManager()
    
    let aboutWindowStoryboard = NSStoryboard(name: "AboutWindowStoryboard", bundle: nil)
    var aboutWindowWindowController: NSWindowController?
    
    
    func showProOnboarding() {
        
        if let controller = aboutWindowWindowController, let window = controller.window, window.isVisible {
            return
        }
 
        DispatchQueue.main.async {
        
            
            self.aboutWindowWindowController = self.aboutWindowStoryboard.instantiateController(withIdentifier: "HLLAboutWindowController") as? NSWindowController
            self.aboutWindowWindowController!.window!.delegate = self
            self.aboutWindowWindowController!.window!.collectionBehavior = .canJoinAllSpaces
            self.aboutWindowWindowController!.window?.title = "How Long Left"
            self.aboutWindowWindowController!.window?.isMovableByWindowBackground = true
            NSApp.setActivationPolicy(.regular)
            self.aboutWindowWindowController!.showWindow(self)
            self.aboutWindowWindowController!.window?.center()
            NSApp.activate(ignoringOtherApps: true)
            
        
        }
            
        }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
    
        aboutWindowWindowController = nil
        return true
        
    }
    
    
}
