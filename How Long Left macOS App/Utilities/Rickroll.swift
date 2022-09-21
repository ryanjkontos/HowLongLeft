//
//  Rickroll.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 5/8/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import AVFoundation


class Rickroll: NSObject {
    
    let rickrollAfterMinutesRemaining = 30
    let range = 1...1
    
    static var shared = Rickroll()
    let rickrollURL = URL(string: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")!
    var rickrolledEvents = [HLLEvent]()
    
    func checkRickrollForEvents(events: [HLLEvent]) {
        
        let secsNeeded = rickrollAfterMinutesRemaining*60
        
        if UserGrouping.shared.getCurrentGroup() == .Rickroll, HLLDefaults.defaults.bool(forKey: "Rickrolled") == false {
            
            for event in events {
            
                if event.title == "IPT" {
                
                if Int(event.endDate.timeIntervalSince(CurrentDateFetcher.currentDate)) < secsNeeded, !rickrolledEvents.contains(event) {
                    
                    rickrolledEvents.append(event)
                
                    if Int.random(in: range) == range.lowerBound {
                
                        rickroll()
                
                    }
                
                }
                    
                }
                
            }
            
        }
        
    }
    
    func rickroll() {
        
        HLLDefaults.defaults.set(true, forKey: "Rickrolled")
        setVolumeMax()
        NSWorkspace.shared.open(rickrollURL)
        
    }
    
    func setVolumeMax() {
    
        
        let myAppleScript = "set volume output volume 100"
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            let _ = scriptObject.executeAndReturnError(
                &error)
            
        }
        
    }
    
    
    
}
