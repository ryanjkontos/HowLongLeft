//
//  CountdownStringGenerator.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class CountdownStringGenerator {
    
    static var shared = CountdownStringGenerator()
    
    let pecentageCalc = PercentageCalculator()
    
    func generateStatusItemString(event: HLLEvent?, mode: StatusItemMode) -> String? {
        
        var returnVal: String?
        
        if let event = event {
        
        switch mode {
        case .Off:
            break
        case .Timer:
            returnVal = generateStatusItemPositionalString(event: event)
        case .Minute:
            returnVal = generateStatusItemMinuteModeString(event: event)
        }
            
        }
        
        return returnVal
        
    }
    
    
    func generateStatusItemPositionalString(event: HLLEvent) -> String {
            
        let returnString = generatePositionalCountdown(event: event)
        return modifyForUserStatusItemPreferences(string: returnString, event: event)
        
    }
    
    
    func generatePositionalCountdown(event: HLLEvent, allowFullUnits: Bool = false, at atDate: Date = Date(), showSeconds: Bool = true) -> String {
        
        var secondsLeft = event.countdownDate(at: atDate).timeIntervalSince(atDate)
        secondsLeft.round(.down)
        
        
        
        if secondsLeft < 0 {
            secondsLeft = -1
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        
        
        
        if secondsLeft < 60 {
            
            formatter.zeroFormattingBehavior = [ .pad ]
            
        } else {
            
           formatter.zeroFormattingBehavior = [ .default ]
            
        }
    
        if secondsLeft >= TimeInterval.year {
            
            formatter.allowedUnits = [.year]
            secondsLeft += TimeInterval.year
            formatter.unitsStyle = .abbreviated
            
        } else if secondsLeft >= TimeInterval.week {
            
            formatter.allowedUnits = [.day, .weekOfMonth]
            secondsLeft += TimeInterval.day
            
        } else if secondsLeft >= TimeInterval.day {
            
            formatter.allowedUnits = [.day, .hour, .minute, .second]
            secondsLeft += TimeInterval.second
            
        } else {
            
            if HLLDefaults.statusItem.hideTimerSeconds == true {
                
                formatter.zeroFormattingBehavior = [ .pad ]
                formatter.allowedUnits = [.hour]
                secondsLeft += TimeInterval.minute
              //  formatter.unitsStyle = .abbreviated
                
            } else {
                
                
                formatter.allowedUnits = [.second]
                secondsLeft += TimeInterval.second
                
                
            }
            
            if secondsLeft >= TimeInterval.hour {
            
            formatter.allowedUnits.insert(.hour)
            formatter.allowedUnits.insert(.minute)
            
        } else {
            
            formatter.allowedUnits.insert(.minute)
            
        }
            
            
        }
        
        if allowFullUnits, !formatter.allowedUnits.contains(.second), !formatter.allowedUnits.contains(.minute), !formatter.allowedUnits.contains(.hour) {

            formatter.unitsStyle = .full
            
        }
        
        if showSeconds == false {
            formatter.allowedUnits.remove(.second)
            formatter.unitsStyle = .abbreviated
        }
            
        formatter.formattingContext = .listItem
        return formatter.string(from: secondsLeft)!
    
    }

    
    func generateStatusItemMinuteModeString(event: HLLEvent) -> String {
        
        var secondsLeft: TimeInterval
        
        if event.completionStatus == .upcoming {
            
            secondsLeft = event.startDate.timeIntervalSince(CurrentDateFetcher.currentDate)
            
        } else {
            
            secondsLeft = event.endDate.timeIntervalSince(CurrentDateFetcher.currentDate)
            
        }
        
        secondsLeft.round(.down)
        
        var returnString: String
            
        let formatter = DateComponentsFormatter()
        
        if HLLDefaults.statusItem.useFullUnits == true {
            formatter.unitsStyle = .full
        } else {
            formatter.unitsStyle = .abbreviated
        }
        
        if secondsLeft >= TimeInterval.year {
            
            formatter.allowedUnits = [.year]
            secondsLeft += TimeInterval.year
            
        } else if secondsLeft >= TimeInterval.week {
            
            formatter.allowedUnits = [.day, .weekOfMonth]
            secondsLeft += TimeInterval.day
            
        } else if secondsLeft >= TimeInterval.day {
            
            formatter.allowedUnits = [.day, .hour, .minute]
            secondsLeft += TimeInterval.minute
            
        } else {
            
        secondsLeft += TimeInterval.minute
            
        if secondsLeft >= TimeInterval.hour {
            
            formatter.allowedUnits = [.minute, .hour]
            
            
            
        } else {
           
            formatter.allowedUnits = [.minute]
            
        }
            
        }
            
        var countdownText = formatter.string(from: secondsLeft)!
            
        if countdownText.last == "." {
            countdownText = String(countdownText.dropLast())
        }
            
        returnString = modifyForUserStatusItemPreferences(string: countdownText, event: event)
        
        return returnString
 
    }
    
    
    func modifyForUserStatusItemPreferences(string: String, event: HLLEvent) -> String {
        
        var returnString = string
        
        if event.completionStatus == .upcoming {
            returnString = "in \(returnString)"
            
        }
        
        var title: String?
        
        if HLLDefaults.statusItem.showTitle == true {
            
            title = titleForStatusItem(event: event)
            
            if let safeTitle = title {
                returnString = "\(safeTitle): \(returnString)"
            }
            
        }
        
        if HLLDefaults.statusItem.showLeftText == true, event.completionStatus != .upcoming {
            
            returnString = "\(returnString) left"
        }
        
        if HLLDefaults.statusItem.showEndTime == true {
            
            var date = event.endDate
            
            if event.completionStatus == .upcoming {
                
                date = event.startDate
                
            }
            
            returnString = "\(returnString) (\(date.formattedTime()))"
            
        }
        
        if HLLDefaults.statusItem.showPercentage == true, event.completionStatus != .upcoming {
            if let percent = pecentageCalc.optionalCalculatePercentageDone(for: event) {
            returnString = "\(returnString) (\(percent))"
            }
        }
        
        
        
        return returnString
        
    }
    
    func titleForStatusItem(event: HLLEvent) -> String? {
    
            var returnValue: String?
                
            if HLLDefaults.statusItem.limitStatusItemTitle {
                let limit = HLLDefaults.statusItem.statusItemTitleLimit
                                   
                if limit > 4 {
                    returnValue = event.title.truncated(limit: limit)
                }
                    
            } else {
                returnValue = event.title
            }
                
            return returnValue
                
    
    }
    
    enum EventDate {
        case Start
        case End
    }
    
    func generateCountdownTextFor(event: HLLEvent, currentDate: Date = CurrentDateFetcher.currentDate, showEndTime: Bool
        = true, force: EventDate? = nil, round: Bool = true, allowSeconds: Bool = false) -> CountdownText {
        
        var mainText: String
        var percentText: String?
        
        var secondsLeft: TimeInterval
        
        if event.completionStatus == .upcoming {
            
            secondsLeft = event.startDate.timeIntervalSince(currentDate)
            
        } else {
            
            secondsLeft = event.endDate.timeIntervalSince(currentDate)
            
        }
        
        if let safeForce = force {
            
            if safeForce == .Start {
                
                secondsLeft = event.startDate.timeIntervalSince(currentDate)
                
            }
            
            if safeForce == .End {
                
                secondsLeft = event.endDate.timeIntervalSince(currentDate)
                
            }
            
        }
        
        let formatter = DateComponentsFormatter()
        
      if secondsLeft >= TimeInterval.year {
            
            formatter.allowedUnits = [.year]
            if round {
            secondsLeft += TimeInterval.year
            }
            
        } else if secondsLeft >= TimeInterval.week {
            
            formatter.allowedUnits = [.day, .weekOfMonth]
            secondsLeft += TimeInterval.day
            
        } else if secondsLeft >= TimeInterval.day {
            
            formatter.allowedUnits = [.day, .hour]
            if round {
            secondsLeft += TimeInterval.hour
            }
            
        } else {
            
            if round {
            secondsLeft += TimeInterval.minute
            }
            
            if secondsLeft >= TimeInterval.hour {
                
                formatter.allowedUnits = [.minute, .hour, .second]
                
            } else {
                
                formatter.allowedUnits = [.minute, .second]
                
            }
            
        }
        
        if allowSeconds == false {
            formatter.allowedUnits.remove(.second)
        }
        
        
        formatter.unitsStyle = .full
        let countdownText = formatter.string(from: TimeInterval(secondsLeft))!
        
        let title = event.title.truncated(limit: 25, position: .middle, leader: "...")
        
        if event.endDate.startOfDay() == CurrentDateFetcher.currentDate.startOfDay(), showEndTime == true {
            
            mainText = "\(title) \(event.countdownTypeString) \(countdownText), at \(event.endDate.formattedTime())."
            
        } else {
            
            mainText = "\(title) \(event.countdownTypeString) \(countdownText)."
            
        }
        
        
        if HLLDefaults.general.showPercentage, event.completionStatus == .current {
            percentText = "\(event.completionPercentage)"
            
        }
        
        
        
        return CountdownText(mainText: mainText, percentageText: percentText, justCountdown: countdownText)
        
    }
    
    
}
