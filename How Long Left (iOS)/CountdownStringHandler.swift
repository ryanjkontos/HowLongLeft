//
//  CountdownStringHandler.swift
//  How Long Left
//
//  Created by Ryan Kontos on 28/1/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation

class CountdownHandler {
    
    let cal = EventDataSource.shared
    let countdownTimer = RepeatingTimer(time: 0.1)
    var thedelegate: HLLCountdownUI
    let timerStringGenerator = EventCountdownTimerStringGenerator()
    let useOnlyInitalEvent: Bool
    let initalEvent: HLLEvent?
    
    init(delegate: HLLCountdownUI, continuous: Bool) {
        
        thedelegate = delegate
        useOnlyInitalEvent = !continuous
        initalEvent = cal.getCurrentEvent()
        
        
        countdownTimer.eventHandler = {
            
            self.updateTimer()
            
        }
        
        countdownTimer.resume()
        
        
    }
    
    func updateTimer() {
        
        var r: String?
        
        if let currentEvent = getEvent() {
            
          r = timerStringGenerator.generateStringFor(event: currentEvent)
            
        }
        
        thedelegate.setCountdownString(r)
        
    }
    
    func getEvent() -> HLLEvent? {
        
        if useOnlyInitalEvent == true {
            
            if let calCurrent = cal.getCurrentEvent(), let inital = initalEvent {
                
                if calCurrent == inital {
                    
                    return calCurrent
                    
                }
                
            }
            
            return nil
            
        } else {
            
            return cal.getCurrentEvent()
            
        }
        
        
    }
    
    
    
    
}

protocol HLLCountdownUI {
    func setCountdownString(_ text: String?)
    func countingDownEventChanged(_ event: HLLEvent)
}
