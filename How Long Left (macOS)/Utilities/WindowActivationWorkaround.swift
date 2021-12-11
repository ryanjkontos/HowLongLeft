//
//  WindowActivationWorkaround.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class WindowActivationWorkaround {

    static var shared = WindowActivationWorkaround()
    
    func runWorkaroundFor(for window: NSWindow?) {
        
        if let safeWindow = window {
        
        NSApp.setActivationPolicy(.regular)
                  NSApp.activate(ignoringOtherApps: true)
                safeWindow.makeKeyAndOrderFront(nil)

                 if (NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.dock").first?.activate(options: []))! {
                     let deadlineTime = DispatchTime.now() + .milliseconds(200)
                     DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                     NSApp.setActivationPolicy(.regular)
                          NSApp.activate(ignoringOtherApps: true)
                        safeWindow.makeKeyAndOrderFront(nil)
                     }
                 }
            
        }
               
        
    }

}
