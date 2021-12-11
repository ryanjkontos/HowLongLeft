//
//  MagdaleneMirror.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 15/5/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

class MagdaleneMirror {
    
    let mirrorEventSource = HLLEventSource()
    
    func setupMirror() throws {
        
        let eventStore = mirrorEventSource.eventStore
        
        var mirrorCalendar: EKCalendar?
        var mirrorOrigin: EKCalendar?
        
        for calendar in eventStore.calendars(for: .event) {
            
            if calendar.title == "Timetable 2020" {
                
                mirrorOrigin = calendar
                break
                
            }
            
        }
        
        if let id = HLLDefaults.defaults.string(forKey: "MirrorID") {
            
            if let calendar = eventStore.calendar(withIdentifier: id) {
                mirrorCalendar = calendar
            }
            
        }
        
        if mirrorCalendar == nil {
            
            let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
            newCalendar.title = "Timetable"
            
            let sourcesInEventStore = eventStore.sources
            
            var mirrorSource: EKSource!
            
            mirrorSource = sourcesInEventStore.filter({$0.sourceType == .calDAV}).first
            
            if mirrorSource == nil {
                mirrorSource = sourcesInEventStore.filter({$0.sourceType == .local}).first
                
            }
            
            if mirrorSource == nil {
                throw MirrorError.couldNotCreateCalendar
            }
            
            newCalendar.source = mirrorSource
            
            do {
                try eventStore.saveCalendar(newCalendar, commit: true)
                HLLDefaults.defaults.set(newCalendar.calendarIdentifier, forKey: "MirrorID")
            } catch {
                throw MirrorError.couldNotSaveCalendar
            }
            
        }
        
        var mirrorCalendarEvents = [HLLEvent]()
        
        let start = Date().startOfDay()
        let end = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
        
        if let mirrorCal = mirrorCalendar, let originCal = mirrorOrigin {
            
            let originEvents = mirrorEventSource.getEventsFromCalendar(start: start, end: end, useCalendar: originCal)
            let mirrorEvents = mirrorEventSource.getEventsFromCalendar(start: start, end: end, useCalendar: mirrorCal)
            
            
            for event in originEvents {
                
                if mirrorEvents.contains(event) == false {
                    mirrorCalendarEvents.append(event)
                }
                
            }
            
        
        
        for originEvent in mirrorCalendarEvents {
            
            print("Trying to save \(originEvent.title)")
            
            let event = EKEvent(eventStore: self.mirrorEventSource.eventStore)
            event.title = originEvent.title
            event.startDate = originEvent.startDate
            event.endDate = originEvent.endDate
            event.calendar = mirrorCal
            
            do {
                try self.mirrorEventSource.eventStore.save(event, span: .thisEvent, commit: true)
                
            } catch {
                
                print("Save didnt work because \(error)")
            }
         
        }
        }
    
        
    }
    
    
    
    
    
}

enum MirrorError: Error {
    
    case couldNotCreateCalendar
    case couldNotSaveCalendar
    
}
