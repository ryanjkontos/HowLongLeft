//
//  HLLStatusItemUpdateHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class HLLStatusItemUpdateHandler {
    
    var mainTimer: Timer!
    weak var activeTimer: Timer?
    
    let initDate = Date()
    
    var delegate: HLLStatusItemManager?
    
    let queue = DispatchQueue(label: "HLLTimerQueue", qos: .userInteractive)
    
    var timer: DispatchSourceTimer!
    
    var lastSecond: String?
    
    let formatter = DateFormatter()
    
    init(delegate: HLLStatusItemManager) {
        
        formatter.dateFormat = "ss"
        
        
        self.delegate = delegate
        
        HLLEventSource.shared.addeventsObserver(self, immediatelyNotify: true)
        
        setActiveMode()
        self.mainUpdate()
        
 
        
            let main = Timer(timeInterval: 4, target: self, selector: #selector(self.mainUpdate), userInfo: nil, repeats: true)
            main.tolerance = 1.5
            RunLoop.main.add(main, forMode: .common)
             self.mainTimer = main
            
    
       
    }
    

    
    @objc func mainUpdate() {
        
   
       
            if let delegate = self.delegate {
                for statusItem in delegate.allStatusItems {
                    statusItem.contentGen.updateEvent()
                }
            }
       
        
    }
    
    
    @objc func activeUpdate() {
        
      
        
        let cur = formatter.string(from: Date())
        
        if let s = lastSecond {
            if s == cur {
                return
            }
        }
        
        lastSecond = cur

        
            if let delegate = self.delegate {
                for statusItem in delegate.allStatusItems {
                    statusItem.updateContent()
                }
            }
            
    }
    
    func setActiveMode() {

        
        activeTimer?.invalidate()
        activeTimer = nil
        
        let date = Calendar.current.date(bySetting: .nanosecond, value: 0, of: Date().addingTimeInterval(1))!
                    
        queue.async {
            
            let active = Timer(fireAt: date, interval: 0.1, target: self, selector: #selector(self.activeUpdate), userInfo: nil, repeats: true)
            active.tolerance = 0
            
            RunLoop.main.add(active, forMode: .common)
            
            self.activeTimer = active
            
            self.activeUpdate()
            
        }
                    
                
                
    }
            

    
    func shouldUseActiveTimerMode() -> Bool {
        
        if HLLEventSource.shared.neverUpdatedevents {
            return true
        }
        
        if self.initDate.timeIntervalSinceNow > -10 {
            return true
        }
        
        if HLLDefaults.statusItem.mode == .Off {
            return false
        }
        
        if SelectedEventManager.shared.selectedEvent != nil {
            return true
        }
        
        if !HLLDefaults.statusItem.showCurrent, !HLLDefaults.statusItem.showUpcoming {
            return false
        }
       
        
        for statusItem in HLLStatusItemManager.shared.allStatusItems {
            
            if let event = statusItem.configuration.eventRetriver.retrieveEvent() {
                
                if HLLDefaults.statusItem.showUpcoming {
                    if event.completionStatus == .upcoming {
                    return true
                }
                
                }
                
                if HLLDefaults.statusItem.showCurrent {
                if event.completionStatus == .current {
                    return true
                }
                
                }
                
            }
            
        }
        
        for date in HLLEventSource.shared.eventsKeyDates {
            
            // 0 = right now
            // 1 = in 1 second
            // -1 = 1 second ago
            
            let timeUntil = date.timeIntervalSince(CurrentDateFetcher.currentDate)
            
            // If date is in less than 5 seconds and
            
            if timeUntil < 5, timeUntil > -5 {
                
                return true
                
            }
            
            
            
        }
        
        return false
        
    }
    
    
}

extension HLLStatusItemUpdateHandler: EventSourceUpdateObserver {
    
    func eventsUpdated() {
        mainUpdate()
        activeUpdate()
    }
    
}

extension HLLStatusItemUpdateHandler: HLLProStatusObserver {
    
    
    func proStatusChanged(from previousStatus: Bool, to newStatus: Bool) {
        //setActiveMode()
    }
    
    
}
