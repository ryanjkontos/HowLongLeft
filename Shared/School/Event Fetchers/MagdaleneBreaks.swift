//
//  MagdaleneBreaks.swift
//  How Long Left
//
//  Created by Ryan Kontos on 1/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class MagdaleneBreaks {
    
    static let shared = MagdaleneBreaks()
    
    func genStartDateTimeKey(event: HLLEvent) -> String {
        
        return "\(event.startDate.formattedTime()) \(event.startDate.formattedDate())"
        
    }
    
    func genEndDateTimeKey(event: HLLEvent) -> String {
        
        return "\(event.endDate.formattedTime()) \(event.endDate.formattedDate())"
        
    }
    
    var debug = false
    
    func getBreaks(events: [HLLEvent], overrideDefaults: Bool = false) -> [HLLEvent] {
        
        // Check if the day's current events line up with a Magdalene timetable, if so return EKEvents of Lunch and Recess
        
        if overrideDefaults {
            
            print("Getting breaks from \(events.count) source events")
            
        }
        
        var returnArray = [HLLEvent]()
        
        if !HLLDefaults.magdalene.showBreaks, !overrideDefaults {
            return returnArray
        }
        
        var addedRecessDates = [String]()
        var addedLunchDates = [String]()
        
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
        
        for event in checkEvents {
            
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
            
            if let recessEvent = getRecessForDate(event.startDate), let endTimes = endTimesDictionary[startMidnight], let startTimes = startTimesDictionary[startMidnight], !addedRecessDates.contains(startMidnight) {
                
                //print("Endtimescount \(endTimes.count)")
                
                if (endTimes.contains(recessEvent.startDate.idString()) || startTimes.contains(recessEvent.endDate.idString())), !startTimes.contains(recessEvent.startDate.idString()), !endTimes.contains(recessEvent.endDate.idString()) {
                
                    
                    returnArray.append(recessEvent)
                    addedRecessDates.append(startMidnight)
                    
                }
                
                
            }

            if let lunchEvent = getLunchForDate(event.startDate), let endTimes = endTimesDictionary[startMidnight], let startTimes = startTimesDictionary[startMidnight], !addedLunchDates.contains(startMidnight) {
        
        
                
                
                if (endTimes.contains(lunchEvent.startDate.idString()) || startTimes.contains(lunchEvent.endDate.idString())), !startTimes.contains(lunchEvent.startDate.idString()), !endTimes.contains(lunchEvent.endDate.idString()) {
                    
                    returnArray.append(lunchEvent)
                    addedLunchDates.append(startMidnight)
                    
                }
                
                
            }


        }
        

        
        return returnArray
        
    }
    
    private func getRecessForDate(_ date: Date) -> HLLEvent? {
        
        var start: Date?
        var end: Date?
        
        var returnEvent: HLLEvent?
        
        if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
            let components = calendar.components([.weekday], from: date)
            if let weekday = components.weekday {
                
                let currentCalendar = Calendar.current
                let dateComponents = currentCalendar.dateComponents([.year, .month, .day], from: date)
                
                if  weekday == Weekday.Monday || weekday == Weekday.Wednesday || weekday == Weekday.Thursday || weekday == Weekday.Friday {
                    
                    var startComponents = dateComponents
                    startComponents.hour = 9
                    startComponents.minute = 50
                    startComponents.second = 00
                    start = calendar.date(from: startComponents)!
                    
                    var endComponents = dateComponents
                    endComponents.hour = 10
                    endComponents.minute = 05
                    endComponents.second = 00
                    end = calendar.date(from: endComponents)!
                    
                } else {
                    
                    var startComponents = dateComponents
                    startComponents.hour = 10
                    startComponents.minute = 15
                    startComponents.second = 00
                    start = calendar.date(from: startComponents)!
                    
                    var endComponents = dateComponents
                    endComponents.hour = 10
                    endComponents.minute = 30
                    endComponents.second = 00
                    end = calendar.date(from: endComponents)!
                    
                }
                
                if let recessStart = start, let recessEnd = end {
                    
                    var event = HLLEvent(title: "Recess", start: recessStart, end: recessEnd, location: nil)
                    event.isMagdaleneBreak = true
                    event.useSchoolCslendarColour = true
                    event.isUserHideable = true
                    event.associatedCalendar = SchoolAnalyser.schoolCalendar
                    returnEvent = event
                    
                }
                        
 
                }
                
            }
        returnEvent?.visibilityString = .breaks
        return returnEvent
        
    }
    
    private func getLunchForDate(_ date: Date) -> HLLEvent? {
        
        var start: Date?
        var end: Date?
        
        var returnEvent: HLLEvent?
        
        if let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian) {
            let components = calendar.components([.weekday], from: date)
            if let weekday = components.weekday {
                
                let currentCalendar = Calendar.current
                let dateComponents = currentCalendar.dateComponents([.year, .month, .day], from: date)
                
                if weekday == Weekday.Monday || weekday == Weekday.Wednesday || weekday == Weekday.Thursday || weekday == Weekday.Friday {
                    
                    var lunchStartComponents = dateComponents
                    lunchStartComponents.hour = 12
                    lunchStartComponents.minute = 40
                    lunchStartComponents.second = 00
                    start = calendar.date(from: lunchStartComponents)!
                    
                    var lunchEndComponents = dateComponents
                    lunchEndComponents.hour = 13
                    lunchEndComponents.minute = 15
                    lunchEndComponents.second = 00
                    end = calendar.date(from: lunchEndComponents)!
                    
                    
                } else {
                    
                    var lunchStartComponents = dateComponents
                    lunchStartComponents.hour = 12
                    lunchStartComponents.minute = 25
                    lunchStartComponents.second = 00
                    start = calendar.date(from: lunchStartComponents)!
                    
                    var lunchEndComponents = dateComponents
                    lunchEndComponents.hour = 12
                    lunchEndComponents.minute = 55
                    lunchEndComponents.second = 00
                    end = calendar.date(from: lunchEndComponents)!
                    
                }
                
                if let lunchStart = start, let lunchEnd = end {
                    
                    var event = HLLEvent(title: "Lunch", start: lunchStart, end: lunchEnd, location: nil)
                    event.isMagdaleneBreak = true
                    event.isUserHideable = true
                    event.useSchoolCslendarColour = true
                    event.associatedCalendar = SchoolAnalyser.schoolCalendar
                    returnEvent = event
                    
                }
                
                
            }
            
        }
        
        returnEvent?.visibilityString = .breaks
        return returnEvent
        
    }
    
    
}

