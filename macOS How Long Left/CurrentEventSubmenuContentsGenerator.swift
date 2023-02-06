//
//  CurrentEventSubmenuContentsGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 8/3/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation

class CurrentEventSubmenuContentsGenerator {
    
    static var shared = CurrentEventSubmenuContentsGenerator()
    
    func generateSubmenuContentsFor(event: HLLEvent) -> [[String]] {
        
        var arrayOne = [String]()
        
        switch event.completionStatus {
            
        case .NotStarted:
            arrayOne.append("Upcoming Event: \(event.title)")
        case .InProgress:
            arrayOne.append("On Now: \(event.title)")
        case .Done:
            arrayOne.append("Completed Event: \(event.title)")
        }
        
        if event.completionStatus == .NotStarted {
            
            var secondsTo = event.startDate.timeIntervalSinceNow+60
            // let minutesLeft = Int(secondsLeft/60+1)
            // let minText = MinutePluralizer(Minutes: minutesLeft)
            
            let formatter1 = DateComponentsFormatter()
            
            if secondsTo+1 > 86400 {
                secondsTo += 86400
                formatter1.allowedUnits = [.day]
                
            } else if secondsTo+1 > 3599 {
                
                formatter1.allowedUnits = [.hour, .minute]
                
            } else {
                
                formatter1.allowedUnits = [.minute]
                
            }
            
            formatter1.unitsStyle = .full
            let timeUntilStartString = formatter1.string(from: secondsTo)!
            
            arrayOne.append("Starts in \(timeUntilStartString).")
            
        }
        
        var arrayTwo = [String]()
        
       
        if event.startDate.formattedDate() != event.endDate.formattedDate() || event.startDate.formattedDate() != Date().formattedDate() {
            
            arrayTwo.append("Start: \(event.startDate.formattedDate()), \(event.startDate.formattedTime())")
            arrayTwo.append("End: \(event.endDate.formattedDate()), \(event.endDate.formattedTime())")
            
            
        } else {
            
            
            arrayTwo.append("Start: \(event.startDate.formattedTime())")
            arrayTwo.append("End: \(event.endDate.formattedTime())")
            
        }
        
        
        
        
        if let period = event.magdalenePeriod {
            
            arrayTwo.append("Period: \(period)")
            
            
        }
        
        if let loc = event.location {
            
            if loc.contains(text: "Room:") {
                
                arrayTwo.append(loc)
                
            } else {
                
                arrayTwo.append("Location: \(loc)")
                
            }
            
        }
        
        var secondsLeft = event.duration
        // let minutesLeft = Int(secondsLeft/60+1)
        // let minText = MinutePluralizer(Minutes: minutesLeft)
        
        if let percentage = PercentageCalculator().calculatePercentageDone(event: event, ignoreDefaults: true), event.completionStatus == .InProgress {
            
            
            arrayTwo.append("Completion: \(percentage)")
            
        }
        
        
        
        var secondsElapsed = Date().timeIntervalSince(event.startDate)
        // let minutesLeft = Int(secondsLeft/60+1)
        // let minText = MinutePluralizer(Minutes: minutesLeft)
        
        let formatter1 = DateComponentsFormatter()
        
        if secondsElapsed+1 > 86400 {
            secondsElapsed += 86400
            formatter1.allowedUnits = [.day]
            
        } else if secondsElapsed+1 > 3599 {
            
            formatter1.allowedUnits = [.hour, .minute]
            
        } else {
            
            formatter1.allowedUnits = [.minute]
            
        }
        
        formatter1.unitsStyle = .full
        let elapsed = formatter1.string(from: secondsElapsed)!
        
        if event.completionStatus == .InProgress {
        
        arrayTwo.append("Elapsed: \(elapsed)")
            
        }
        
        let formatter = DateComponentsFormatter()
        
        if secondsLeft+1 > 86400 {
            secondsLeft += 86400
            formatter.allowedUnits = [.day, .weekOfMonth]
            
        } else if secondsLeft+1 > 3599 {
            
            formatter.allowedUnits = [.hour, .minute]
            
            secondsLeft -= 8640
            
        } else {
            
            formatter.allowedUnits = [.minute]
            
        }
        
        formatter.unitsStyle = .full
        let countdownText = formatter.string(from: event.duration)!
        
        
        arrayTwo.append("Duration: \(countdownText)")
        
        if let cal = event.calendar?.title {
            
            arrayTwo.append("Calendar: \(cal)")

            
        }
        
        
        return [arrayOne, arrayTwo]
        
        
    }
    
    
}
