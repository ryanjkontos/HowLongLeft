//
//  UpcomingEventSource.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 20/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import Combine

class UpcomingEventSource: ObservableObject {

    @Published var events = [DateOfEvents]()
    
    var timer: Timer!

    var isEmpty: Bool {
        get {
            return events.isEmpty
        }
    }
    
    init() {
        
        HLLEventSource.shared.addEventPoolObserver(self)
        
        update()
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
    }
    
    @objc func update() {
        
      //  print("UES Updating")
 
        let start = Date().startOfDay()
        let end = start.addDays(100)
        
        let newEvents = HLLEventSource.shared.getArraysOfUpcomingEventsForDates(startDate: start, endDate: end, returnEmptyItems: false)
        if self.events != newEvents {
            print("Upcoming set")
            self.events = newEvents
        }
        
    
    }

}

extension UpcomingEventSource: EventPoolUpdateObserver {
    
    func eventPoolUpdated() {
        
        DispatchQueue.main.async {
            self.update()
        }
        
    }
    
}
