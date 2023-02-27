//
//  EventMonitor.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 28/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class EventChangeMonitor {
    
    static let shared = EventChangeMonitor()
    
    private var observers = [EventChangeObserver]()
    
    private var timer: Timer!
    
    private var previousevents = [HLLEvent]()
    
    private var statusDict = [HLLEvent: HLLEvent.CompletionStatus]()
    
    init() {
        setupTimer()
    }
    
    func addObserver(_ newObserver: EventChangeObserver) {
        observers.append(newObserver)
        newObserver.eventsChanged()
    }
    
    private func run() {
        
        let prev = previousevents
        let current = HLLEventSource.shared.events
        
        let prevSet = Set(prev.map({$0.infoIdentifier}))
        let currentSet = Set(current.map({$0.infoIdentifier}))
        
        if prevSet == currentSet, statusDict != generateStatusDict(current) {
            
           // // print("Current and previous mismatch")
            
            DispatchQueue.main.async {
                
                
                self.updateAppForChanges()
             
                self.statusDict = self.generateStatusDict(current)
                
            }
        } else {
          //  // print("Current and previous match")
        }
        
        self.previousevents = current
        
    }
    
    private func generateStatusDict(_ events: [HLLEvent]) -> [HLLEvent: HLLEvent.CompletionStatus] {
        
        let date = Date()
        
        var dict = [HLLEvent: HLLEvent.CompletionStatus]()
        
        for event in events {
            dict[event] = event.completionStatus(at: date)
        }
        
        return dict
        
    }
  
    func setupTimer() {
        
        
        DispatchQueue.main.async {
            let timer = Timer(timeInterval: 1, repeats: true) { _ in
                
                    self.run()
                
            }
            let runLoop = RunLoop.main
            runLoop.add(timer, forMode: .common)
            self.run()
        }
        
    }
    
    func updateAppForChanges() {
        
        self.observers.forEach({ observer in
            observer.eventsChanged()
        })
        
    }
    
}


protocol EventChangeObserver {
    
    func eventsChanged()
    
}
