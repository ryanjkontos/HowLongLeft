//
//  OnboardingWindowController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import AppKit

class OnboardingWindowController: NSWindowController, NSWindowDelegate {
    
    override func windowDidLoad() {
        
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
            self.window?.center()
           
            self.window?.level = .normal
            self.window?.makeKeyAndOrderFront(nil)
            self.window?.delegate = self
        }
    
    func windowDidEndLiveResize(_ notification: Notification) {
        if let w = self.window {
            
            let width = w.frame.width
            let height = w.frame.height
            
            // print("Window: \(width)*\(height)")
            
        }
    }
    
}

