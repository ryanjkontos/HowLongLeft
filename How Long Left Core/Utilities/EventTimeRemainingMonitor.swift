//
//  EventTimeRemainingMonitor.swift
//  How Long Left
//
//  Created by Ryan Kontos on 22/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//
//  Monitors the time remaining of events.
//

import Foundation

/**
 * Methods for monitoring current events for the purpose of delivering milestone notifications to the delegate.
 */

class EventTimeRemainingMonitor {

    var checkqueue = DispatchQueue(label: "CheckQueue")
    var countdownEvents = [HLLEvent]()
    var checkTimer = Timer()
    var delegate: HLLCountdownController
    var coolingDown = [HLLEvent]()
    var coolingDownPercentage = [HLLEvent]()
    var coolingDownEnded = [HLLEvent]()
    var coolingDownStarted = [HLLEvent]()
    let percentCalc = PercentageCalculator()
    
    
    init(delegate theDelegate: HLLCountdownController) {
        
        delegate = theDelegate
        
    }
    
    func setCurrentEvents(events: [HLLEvent]) {
            self.countdownEvents = events
            
        
    }
    
    func removeAllCurrentEvents() {
            self.countdownEvents.removeAll()
            
        
        
    }
    
    func checkEventProgress(allToday: [HLLEvent]) {
        
        let milestones = HLLDefaults.notifications.milestones
        let percentageMilestones = HLLDefaults.notifications.Percentagemilestones
        let events = allToday
        
        
        for event in events {
            
           // print("Checking \(event.title)")
            
            let timeUntilEnd = event.endDate.timeIntervalSince(CurrentDateFetcher.currentDate)+1
            let secondsUntilEnd = Int(timeUntilEnd)
            
                for milestone in milestones {
                    
                    if secondsUntilEnd == milestone {
                        
                        if milestones.contains(milestone), self.coolingDownPercentage.contains(event) == false {
                            
                            self.coolingDownPercentage.append(event)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                
                                [unowned self] in
                                self.coolingDownPercentage.removeAll()
                            }
                            
                            print("Sending milestone noto at \(CurrentDateFetcher.currentDate)")
                            
                            self.delegate.milestoneReached(milestone: milestone, event: event)
                            
                        
                        }
                        
                    }
                
                }
            
            var percentageMilestoneSeconds = [Int:Int]()
            
            for percent in percentageMilestones {
                
                percentageMilestoneSeconds[percent] = Int(event.duration)-Int(event.duration)/100*percent
            }
            
            for percentSecond in percentageMilestoneSeconds {
                
                
                if secondsUntilEnd == percentSecond.value {
                    
                    
                    if self.coolingDown.contains(event) == false {
                        
                        self.coolingDown.append(event)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            
                            [unowned self] in
                            
                            self.coolingDown.removeAll()
                        }
                        
                        self.delegate.percentageMilestoneReached(milestone: percentSecond.key, event: event)
                        
                        
                    }
                    
                }
                
            }
            
            if timeUntilEnd < 1, timeUntilEnd > -2, self.coolingDownEnded.contains(event) == false {
                    
                   // print("\(event.title) is ending.")
                    
                    var endingNow = true
                    if timeUntilEnd < -5 {
                        endingNow = false
                    }
                
                self.delegate.updateDueToEventEnd(event: event, endingNow: endingNow)
                    
                self.coolingDownEnded.append(event)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        
                        [unowned self] in
                        
                        self.coolingDownEnded.removeAll()
                    }
                    
                   
                }

            
            var startedAtEndOfEvent = false
            
            for eventToday in allToday {
                
                if eventToday.endDate == event.startDate {
                    
                    startedAtEndOfEvent = true
                    
                }
                
            }
            
            let timeUntilStart = event.startDate.timeIntervalSince(CurrentDateFetcher.currentDate)-2
            let secondsUntilStart = Int(timeUntilStart)
            
            if secondsUntilStart < 1, secondsUntilStart > -10, self.coolingDownStarted.contains(event) == false, startedAtEndOfEvent == false {
                
              print("\(event.title) is starting at \(CurrentDateFetcher.currentDate).")
                
                self.delegate.eventStarted(event: event)
                
                self.coolingDownStarted.append(event)
                DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                    
                    [unowned self] in
                    
                    self.coolingDownStarted.removeAll()
                }
                
                
            }

            
            
            
            }
            
        
        
    }
    
}
