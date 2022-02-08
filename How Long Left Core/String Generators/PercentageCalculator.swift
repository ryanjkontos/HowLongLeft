//
//  PercentageCalculator.swift
//  How Long Left
//
//  Created by Ryan Kontos on 14/2/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class PercentageCalculator {
    
    func calculatePercentageDone(for event: HLLEvent, at date: Date = CurrentDateFetcher.currentDate) -> String {
        
        let secondsElapsed = date.timeIntervalSince(event.startDate)
        let totalSeconds = event.endDate.timeIntervalSince(event.startDate)
        var percentOfEventComplete = Int(100*secondsElapsed/totalSeconds)
        
        if percentOfEventComplete > 100 {
            percentOfEventComplete = 100
        }
        
        if percentOfEventComplete < 0 {
            percentOfEventComplete = 0
        }
        
        return "\(percentOfEventComplete)%"
        
    }
    
    func optionalCalculatePercentageDone(for event: HLLEvent, at date: Date = CurrentDateFetcher.currentDate) -> String? {
        
        let secondsElapsed = date.timeIntervalSince(event.startDate)
        let totalSeconds = event.endDate.timeIntervalSince(event.startDate)
        var percentOfEventComplete = Int(100*secondsElapsed/totalSeconds)
        
        if percentOfEventComplete > 100 {
            percentOfEventComplete = 100
        }
        
        if percentOfEventComplete < 0 {
            return nil
        }
        
        return "\(percentOfEventComplete)%"
        
    }
    
    func calculateIntPercentDone(of event: EventUIObject, at date: Date = CurrentDateFetcher.currentDate) -> Int {
        
        let secondsElapsed = date.timeIntervalSince(event.startDate)
        let totalSeconds = event.endDate.timeIntervalSince(event.startDate)
        var percentOfEventComplete = Int(100*secondsElapsed/totalSeconds)
        
        if percentOfEventComplete > 100 {
            percentOfEventComplete = 100
        }
        
        if percentOfEventComplete < 0 {
            percentOfEventComplete = 0
        }
        
        return percentOfEventComplete
        
    }
    
    func completionValue(for event: HLLEvent, at date: Date = Date()) -> Double {
        
        let secondsElapsed = date.timeIntervalSince(event.startDate)
        let totalSeconds = event.endDate.timeIntervalSince(event.startDate)
        
        return Double(secondsElapsed/totalSeconds)
        
    }
    
    
    
}
