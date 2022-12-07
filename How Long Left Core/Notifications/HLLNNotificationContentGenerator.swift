//
//  HLLNNotificationContentGenerator.swift
//  How Long Left
//
//  Created by Ryan Kontos on 25/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLNNotificationContentGenerator {
    
    
    let minutePluraliser = Pluraliser(singular: "minute", plural: "minutes")
    
    func generateNotificationContentItems(for events: [HLLEvent]) -> [HLLNotificationContent] {
        
        var contentItems = [HLLNotificationContent]()
        var startingEventsIncludedInEndNotifications = [HLLEvent]()
        
        
        let milestones = HLLNTriggerFetcher.shared.getTimeRemainingTriggers()
        
       
        
        let startsInMilestones = HLLNTriggerFetcher.shared.getTimeUntilTriggers()
        
       
        
        let percentageMilestones = HLLNTriggerFetcher.shared.getPercentageTriggers()
        
       
        
        for event in events {
            
            // Generate end notification for event.
            
            if HLLDefaults.notifications.endNotifications {
                
                let title = "\(event.truncatedTitle()) is done"
                
                let content = HLLNotificationContent(date: event.endDate)
                content.title = title
                
                let upcomingData = getUpcomingEventData(at: event.endDate, from: events, exclude: event)
                
                if let event = upcomingData.event, upcomingData.startingNow {
                    startingEventsIncludedInEndNotifications.append(event)
                }
                
                content.body = upcomingData.string
                
                content.event = event
                
                contentItems.append(content)
                
            }
            
            // Generate start notification for event.
            
            if HLLDefaults.notifications.startNotifications, !startingEventsIncludedInEndNotifications.contains(event) {
                
                let title = "\(event.truncatedTitle()) is starting now"
                
                let content = HLLNotificationContent(date: event.startDate)
                content.title = title
                if let location = event.location?.truncated(limit: 15) {
                  content.subtitle = "(\(location))"
                }
                
                let upcomingData = getUpcomingEventData(at: event.startDate, from: events, exclude: event)
                content.body = upcomingData.string
                
                content.event = event
                
                contentItems.append(content)
                
            }
            
            // Generate time remaining notifications for event.
            
            for secondsRemaining in milestones {
                
                let date = event.endDate.addingTimeInterval(TimeInterval(0 - secondsRemaining))

                if event.completionStatus(at: date) == .current {
                
                let content = HLLNotificationContent(date: date)
                
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .full
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                let durationString = formatter.string(from: TimeInterval(secondsRemaining))!
                
                    
                let title = "\(event.truncatedTitle()) ends in \(durationString)"
                    
                content.title = title
                    
                let percent = PercentageCalculator.calculatePercentageDone(for: event, at: date)
                    content.subtitle = "(\(percent) done)"
                
                    
            
                    
                let upcomingData = getUpcomingEventData(at: date, from: events, exclude: event)
                content.body = upcomingData.string
                content.event = event
                
                contentItems.append(content)
                    
                }
                
            }
            
            for secondsUntil in startsInMilestones {
                
                let date = event.startDate.addingTimeInterval(TimeInterval(0 - secondsUntil))

                if event.completionStatus(at: date) == .upcoming {
                
                let content = HLLNotificationContent(date: date)
                
                let formatter = DateComponentsFormatter()
                formatter.unitsStyle = .full
                formatter.allowedUnits = [.day, .hour, .minute, .second]
                let durationString = formatter.string(from: TimeInterval(secondsUntil))!
                               
                    
                let title = "\(event.truncatedTitle()) starts in \(durationString)"
                    
                content.title = title
  
                let upcomingData = getUpcomingEventData(at: date, from: events, exclude: event)
                content.body = upcomingData.string
                content.event = event
                
                contentItems.append(content)
                    
                }
                
            }
            
            for percentage in percentageMilestones {
                
                //// print("Genning percent notification for \(percentage)")
                
                let secondsFromStart = Int(event.duration)/100*percentage
                let date = event.startDate.addingTimeInterval(TimeInterval(secondsFromStart))
                
                if event.completionStatus(at: date) == .current {
                
                let content = HLLNotificationContent(date: date)
                content.title = "\(event.truncatedTitle()) is \(percentage)% done."
                content.subtitle = "(\(CountdownStringGenerator.generateCountdownTextFor(event: event, currentDate: date, force: .End, allowSeconds: true).justCountdown) left)"
                let upcomingData = getUpcomingEventData(at: date, from: events, exclude: event)
                content.body = upcomingData.string
                content.event = event
                contentItems.append(content)
                    
                }
                
            }
            
        }
        
      
        
        return contentItems
        
    }
    
    // MARK: Utils for content generation
    
    func getUpcomingEventData(at date: Date, from events: [HLLEvent], exclude event: HLLEvent) -> (event: HLLEvent?, string: String, startingNow: Bool) {
        
        var returnEvent: HLLEvent?
        var returnString = "Nothing next"
        var returnStartingNow = false
        
        if let nextEvent = eventsNotStartedBy(date: date, events: events, exclude: event).first {
            
            returnEvent = nextEvent
            var locationEvent = nextEvent
            
            returnString = "\(nextEvent.title.truncated(limit: 13)) "
            
            if date == nextEvent.startDate {
                returnString += "is starting now"
                returnStartingNow = true
            } else {
                returnString += "starts next"
            }
            
            
            returnString += "."
            
            if let location = locationEvent.location?.truncated(limit: 13) {
                returnString += " (\(location))"
            }
            
        }
        
        return (returnEvent, returnString, returnStartingNow)
        
    }
    
    func eventsNotStartedBy(date: Date, events: [HLLEvent], exclude: HLLEvent) -> [HLLEvent] {
        
        var returnArray = [HLLEvent]()
        
        let sorted = events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        
        for event in sorted {
            
            if event.startDate.timeIntervalSince(date) >= 0, event != exclude {
                
                returnArray.append(event)
                
            }
            
        }
        
        return returnArray
    }
    
    func generateEventNotificationUserInfo(for event: HLLEvent) -> [AnyHashable:Any] {
        
        var returnArray = [AnyHashable:Any]()

        returnArray["eventidentifier"] = event.persistentIdentifier
        
        return returnArray
        
    }
    
}

class HLLEventGroup {
    
    init(_ events: [HLLEvent]) {
        
        self.events = events
    }
    
    var events = [HLLEvent]()
    
    func representativeString() -> String {
        
        let eventsForRepresentation = events
        
        if let first = eventsForRepresentation.first {
        
        if eventsForRepresentation.count == 1 {
            return first.truncatedTitle(20)
        }
            
        let count = eventsForRepresentation.count-1
        return "\(first.truncatedTitle(20)) & \(count) more"
        
        } else {
             return "(No Events)"
        }
        
    }
    
}
