//
//  DockIconVisibilityManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class DockIconVisibilityManager {
    
    static var shared: DockIconVisibilityManager!
    
    init() {
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.didBecomeKey),
        name: NSWindow.didBecomeKeyNotification,
        object: nil)
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.didClose),
        name: NSWindow.willCloseNotification,
        object: nil)
        
    }
    
    @objc func didBecomeKey() {
        
       // // print("Became key")
        checkWindows()
        
    }
    
    @objc func didClose() {
        
        //// print("Did close")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.checkWindows()
            
        }
        
        
        
    }
    
    @objc func checkWindows() {
        
        
        var visible = [NSWindow]()
              
              let windows = NSApplication.shared.windows
              
            for window in windows {
                  
              //  // print("Window \(i): \(window.description)")
                
                if !window.description.contains(text: "NSStatusBarWindow"), !window.description.contains(text: "NSCarbonMenuWindow"), !window.description.contains(text: "NSMenuWindowManagerWindow") {
                      visible.append(window)
                  }
                  
              }
        
        /*for item in visible {
            // print("Visible: \(item.description)")
        }*/
              
              if visible.count > 0 {
                 NSApp.setActivationPolicy(.regular)
              } else {
                  
                NSApp.setActivationPolicy(.accessory)
                  
              }
              
    }
    
    
}
