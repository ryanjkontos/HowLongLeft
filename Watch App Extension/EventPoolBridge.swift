//
//  EventPoolBridge.swift
//  Watch App Extension
//
//  Created by Ryan Kontos on 24/10/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import Swift

class EventPoolBridge: ObservableObject, EventPoolUpdateObserver {
    
    var everUpdatedTimeline = false
    
    var timer: Timer!
    
    @Published var timeline = [HLLEvent]()
    
    init() {
        
        HLLEventSource.shared.getCalendarAccess()
        
        HLLEventSource.shared.updateEventPool()
        
        HLLEventSource.shared.addEventPoolObserver(self, immediatelyNotify: true)
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
    }
    
    @objc func update() {
        
        DispatchQueue.main.async { [self] in
    
       //     print("Bridge update")
            
            let newTimeline = HLLEventSource.shared.getTimeline()
            
            if everUpdatedTimeline == false {
                everUpdatedTimeline = true
                self.timeline = newTimeline
                
            } else {
                
                if self.timeline != newTimeline {
                    
                    print("Unmatched at \(Date())")
                    
                    self.timeline = newTimeline
                }
                
                
            }
            
            
            
        }
        
    }
    
    func eventPoolUpdated() {
    
     update()
        
    }
  
}
