//
//  MemoryRelaunch.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class MemoryRelaunch {
    
    func relaunchIfNeeded() {
        
        // In macOS 10.14 there's a bug where data from the EKEventStore is never released from memory. Since this app reads from the event store frequently and is meant to be running constantly, memory usage builds up over time. The only way I have found to resolve this is to literally relaunch once memory usage exceeds 50MB, whih takes a few hours depending on usage. Ew. I know.
    
        #if DEBUG
        
        
        DispatchQueue.main.async {
            
        
        if NSApp.activationPolicy() != .regular {
            
            var info = mach_task_basic_info()
            var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
            
            let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                    task_info(mach_task_self_,
                              task_flavor_t(MACH_TASK_BASIC_INFO),
                              $0,
                              &count)
                }
            }
            
            if kerr == KERN_SUCCESS {
                
                //  // print("Memory in use: \(info.resident_size/100000)")
                
                if info.resident_size/1000000 > 2000 {
                    // Roughly idk
                    
                    // print("Relaunching to resolve memory issues...")
                    // This is the worst thing I have ever done lmao.
                    self.relaunchApp()
                }
                
            }
            else {
                // print("Error with task_info(): " +
                    (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
            }
            
        }
            
        }
        
        #endif
        
    }
    
    @objc func relaunchApp() {
        
            let url = URL(fileURLWithPath: Bundle.main.resourcePath!)
            let path = url.deletingLastPathComponent().deletingLastPathComponent().absoluteString
            let task = Process()
            task.launchPath = "/usr/bin/open"
            task.arguments = [path]
            task.launch()
            exit(0)

    }
    
    
}
