//
//  MagdaleneExtraEvents.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class MagdaleneTuesdayEvents {
    
    static let shared = MagdaleneTuesdayEvents()
    
    func genStartDateTimeKey(event: HLLEvent) -> String {
        
        return "\(event.startDate.formattedTime()) \(event.startDate.formattedDate())"
        
    }
    
    func genEndDateTimeKey(event: HLLEvent) -> String {
        
        return "\(event.endDate.formattedTime()) \(event.endDate.formattedDate())"
        
    }
    
    var debug = false
    
    func getTuesdayEvents(events: [HLLEvent], overrideDefaults: Bool = false) -> [HLLEvent] {
        
        if overrideDefaults {
            
            print("Getting Tuesday events from \(events.count) source events")
            
        }
        
        var returnArray = [HLLEvent]()
        
        if !HLLDefaults.magdalene.showBreaks, !overrideDefaults {
            return returnArray
        }
        
        var addedSportDates = [String]()
        var addedHomeroomDates = [String]()
        
        var checkEvents = [HLLEvent]()
    
        if overrideDefaults == false {
        
        for event in events {
            
            let value = TimeInterval.day*1.5
            let negativeValue = -value
            
            if event.endDate.timeIntervalSince(CurrentDateFetcher.currentDate) > negativeValue, event.startDate.timeIntervalSince(CurrentDateFetcher.currentDate) < TimeInterval.week*1.5 {
                
                checkEvents.append(event)
                
            }
            
        }
            
        } else {
            
            checkEvents = events
            
        }
        
        var startTimesDictionary = [String:[String]]()
        var endTimesDictionary = [String:[String]]()
        
        for (index, event) in checkEvents.enumerated() {
            
            let startMidnight = event.startDate.formattedDate()
            
            if startTimesDictionary[startMidnight] == nil {
               startTimesDictionary[startMidnight] = [event.startDate.idString()]
            } else {
               startTimesDictionary[startMidnight]!.append(event.startDate.idString())
            }
            
            if endTimesDictionary[startMidnight] == nil {
                endTimesDictionary[startMidnight] = [event.endDate.idString()]
            } else {
                endTimesDictionary[startMidnight]!.append(event.endDate.idString())
            }
            
            if var homeroomEvent = getHomeroomForDate(event.startDate), let endTimes = endTimesDictionary[startMidnight], let startTimes = startTimesDictionary[startMidnight], !addedHomeroomDates.contains(startMidnight) {
                
                
                if checkEvents.indices.contains(index-1) {
                    homeroomEvent.associatedCalendar = checkEvents[index-1].calendar
                }
                
                if (endTimes.contains(homeroomEvent.startDate.idString()) || startTimes.contains(homeroomEvent.endDate.idString())), !startTimes.contains(homeroomEvent.startDate.idString()), !endTimes.contains(homeroomEvent.endDate.idString()) {
                
                    
                    returnArray.append(homeroomEvent)
                    addedHomeroomDates.append(startMidnight)
                    
                }
                
                
            }

            if var sportEvent = getSportForDate(event.startDate), let endTimes = endTimesDictionary[startMidnight], let startTimes = startTimesDictionary[startMidnight], !addedSportDates.contains(startMidnight) {
                
                if checkEvents.indices.contains(index-1) {
                    sportEvent.associatedCalendar = checkEvents[index-1].calendar
                }
                
                if (endTimes.contains(sportEvent.startDate.idString()) || startTimes.contains(sportEvent.endDate.idString())), !startTimes.contains(sportEvent.startDate.idString()), !endTimes.contains(sportEvent.endDate.idString()) {
                    
                    returnArray.append(sportEvent)
                    addedSportDates.append(startMidnight)
                    
                }
                
                
            }


        }
        
        return returnArray
        
    }
    
    private func getHomeroomForDate(_ date: Date) -> HLLEvent? {
        
        var start: Date?
        var end: Date?
        
        var returnEvent: HLLEvent?
        
        if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
            let components = calendar.components([.weekday], from: date)
            if let weekday = components.weekday {
                
                let currentCalendar = Calendar.current
                let dateComponents = currentCalendar.dateComponents([.year, .month, .day], from: date)
                
                if weekday == Weekday.Tuesday {
                    
                    var startComponents = dateComponents
                    startComponents.hour = 10
                    startComponents.minute = 30
                    startComponents.second = 00
                    start = calendar.date(from: startComponents)!
                    
                    var endComponents = dateComponents
                    endComponents.hour = 11
                    endComponents.minute = 25
                    endComponents.second = 00
                    end = calendar.date(from: endComponents)!
                    
                }
                
                if let homeroomStart = start, let homeroomEnd = end {
                    
                    let event = HLLEvent(title: "Homeroom", start: homeroomStart, end: homeroomEnd, location: nil)
                    returnEvent = event
                    
                }
                        
 
                }
                
            }
        
        return returnEvent
        
    }
    
    private func getSportForDate(_ date: Date) -> HLLEvent? {
        
        var start: Date?
        var end: Date?
        
        var returnEvent: HLLEvent?
        
        if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
            let components = calendar.components([.weekday], from: date)
            if let weekday = components.weekday {
                
                let currentCalendar = Calendar.current
                let dateComponents = currentCalendar.dateComponents([.year, .month, .day], from: date)
                
                if weekday == Weekday.Tuesday {
                    
                    var sportStartComponents = dateComponents
                    sportStartComponents.hour = 12
                    sportStartComponents.minute = 55
                    sportStartComponents.second = 00
                    start = calendar.date(from: sportStartComponents)!
                    
                    var sportEndComponents = dateComponents
                    sportEndComponents.hour = 14
                    sportEndComponents.minute = 35
                    sportEndComponents.second = 00
                    end = calendar.date(from: sportEndComponents)!
                    
                    
                }
                
                if let sportStart = start, let sportEnd = end {
                    
                    var title = "Sport"
                    if HLLDefaults.magdalene.showSportAsStudy {
                        title = "Study"
                    }
                    
                    var event = HLLEvent(title: title, start: sportStart, end: sportEnd, location: nil)
                    event.period = "S"
                    returnEvent = event
                    
                }
                
                
            }
            
        }
        
        return returnEvent
        
    }
    
    
}

