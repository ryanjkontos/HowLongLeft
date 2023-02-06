//
//  UtilityRunLoopManager.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation



class UtilityRunLoopManager {
    
    let relaunchManager = MemoryRelaunch()
    
    var timer: Timer!
    var infrequentTimer: Timer!
    
    init() {
        
        DockIconVisibilityManager.shared = DockIconVisibilityManager()
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(run), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        infrequentTimer = Timer(timeInterval: 240, target: self, selector: #selector(infrequentRun), userInfo: nil, repeats: true)
        
        run()
        infrequentRun()
        
    }
    
    @objc func run() {
        
        DockIconVisibilityManager.shared.checkWindows()
        
        if let date = HLLDefaults.statusItem.hideEventsOn {
            if date.startOfDay() != Date().startOfDay() {
                HLLDefaults.statusItem.hideEventsOn = nil
                // print("Async trigger 1")
                HLLEventSource.shared.updateEventsAsync()
            }
        }
        
    }
    
    @objc func infrequentRun() {
        
        ProPurchaseHandler.shared.fetchAvailableProducts()
        relaunchManager.relaunchIfNeeded()
        
    }
    
    
}
