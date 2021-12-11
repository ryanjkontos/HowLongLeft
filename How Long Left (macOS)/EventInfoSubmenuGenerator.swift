//
//  EventInfoSubmenuGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 8/3/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa

class EventInfoSubmenuGenerator {
    
    static var shared = EventInfoSubmenuGenerator()
    
    func generateSubmenuContentsFor(event: HLLEvent) -> NSMenu {
        
        var arrayOne = [String]()
        var arrayTwo = [String]()
        
        switch event.completionStatus {
            
        case .NotStarted:
    
             var secondsTo = event.startDate.timeIntervalSinceNow+60
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
             
             
             arrayOne.append("\(event.title) – in \(timeUntilStartString)")
             
             
            
            //arrayOne.append("\(event.title) (Upcoming)")
        case .InProgress:
            arrayOne.append("\(event.title) (On Now)")
        case .Done:
            arrayOne.append("\(event.title) (Done)")
        }
        
        if event.isAllDay {
            
            arrayOne.append("All day event")
            
        }
        
        arrayOne.append("\(event.startDate.formattedTime())-\(event.endDate.formattedTime())")
        
        if let loc = event.location {
            
            if loc.contains(text: "Room:") {
                
                arrayTwo.append(loc)
                
            } else {
                
                arrayTwo.append("Location: \(loc)")
                
            }
            
            
        }
        
        if let period = event.magdalenePeriod {
            
            arrayTwo.append("Period: \(period)")
            
            
        }
        
        
        
        
        
        
    /*    var startText = "Start"
        var endText = "End"
        
        if event.completionStatus != .NotStarted {
            
            startText = "Started"
            
        }
        
        if event.completionStatus == .Done {
            
            endText = "Ended"
            
        }
        
         
        if event.startDate.formattedDate() != event.endDate.formattedDate() || event.startDate.formattedDate() != Date().formattedDate() {
            
            arrayTwo.append("\(startText) \(event.startDate.formattedDate()), \(event.startDate.formattedTime())")
            arrayTwo.append("\(endText) \(event.endDate.formattedDate()), \(event.endDate.formattedTime())")
            
            
        } else {
            
            
            arrayTwo.append("\(startText) \(event.startDate.formattedTime())")
            arrayTwo.append("\(endText) \(event.endDate.formattedTime())")
            
        } */
        
        
        
        
        
        
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
        
        if event.completionStatus == .Done {
            
            
            var secondsElapsed = Date().timeIntervalSince(event.endDate)
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
            
            arrayTwo.append("Finished: \(elapsed) ago")
            
            
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
        
        if let ek = event.EKEvent, let notes = ek.notes {
            
            let lines = notes.split { $0.isNewline }
            
            for line in lines {
                
                if line.contains("Teacher") {
                    
                    arrayTwo.append(String(line))
                    
                }

                
            }
            
            
        }
        
        
        
        if let cal = event.calendar?.title {
            
            arrayTwo.append("Calendar: \(cal)")

            
        }
        
        let menu = NSMenu()
        
        for item in arrayOne {
            
            let menuItem = NSMenuItem()
            menuItem.title = item
            menu.addItem(menuItem)
            
        }
        
        menu.addItem(NSMenuItem.separator())
        
        for item in arrayTwo {
            
            let menuItem = NSMenuItem()
            menuItem.title = item
            menu.addItem(menuItem)
            
        }
        
        if event.completionStatus == .InProgress {
            
            menu.addItem(NSMenuItem.separator())
            let eventUIWindowButton = NSMenuItem()
            eventUIWindowButton.title = "Open Countdown Window..."
            eventUIWindowButton.target = EventUIWindowsManager.shared
            eventUIWindowButton.action = #selector(EventUIWindowsManager.shared.eventUIButtonClicked(sender:))
            EventUIWindowsManager.shared.addItemWithEvent(item: eventUIWindowButton, event: event)
            menu.addItem(eventUIWindowButton)
        }
        
        
        return menu
        
        
    }
    
    
}
