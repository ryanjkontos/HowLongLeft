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
    
    private var previousEventPool = [HLLEvent]()
    
    private var statusDict = [HLLEvent: HLLEvent.CompletionStatus]()
    
    init() {
        
        setupTimer()
        
    }
    
    func addObserver(_ newObserver: EventChangeObserver) {
        observers.append(newObserver)
        newObserver.eventsChanged()
    }
    
    private func run() {
        
        let prev = previousEventPool
        let current = HLLEventSource.shared.eventPool
        
        if (prev != current) || statusDict != generateStatusDict(current) {
            
           // print("Current and previous mismatch")
            
            observers.forEach({ observer in
                DispatchQueue.main.async {
                    observer.eventsChanged()
                }
            })
            
            timer?.invalidate()
            
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 1) {
                self.setupTimer()
            }
            
            statusDict = generateStatusDict(current)
            previousEventPool = current
            
        } else {
           // print("Current and previous match")
        }
        
        
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
        
        
        
        DispatchQueue.global(qos: .background).async {
            let timer = Timer(timeInterval: 1, repeats: true) { _ in
                DispatchQueue.global(qos: .background).async {
                    self.run()
                }
            }
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: .common)
            runLoop.run()
        }
        
    }
    
}


protocol EventChangeObserver {
    
    func eventsChanged()
    
}
