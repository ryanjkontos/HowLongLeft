//
//  HLLEvent.swift
//  How Long Left
//
//  Created by Ryan Kontos on 16/11/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit


#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

/**
 *  Represents an event in How Long Left.
 */

struct HLLEvent: Equatable, Hashable, Identifiable {

    var id: String {
        
        get {
            
            return infoIdentifier
            
        }
        
    }
    
    
    var title: String
    var shortTitle: String
    var originalTitle: String
    var ultraCompactTitle: String
    var startDate: Date
    var endDate: Date
    var location: String?
    var secondaryRoomName: String?
    var oldLocationSetting = OldRoomNamesSetting.doNotShow
    var newRoomName: String?
    var fullLocation: String?
    var shortLocation: String?
    var holidaysTerm: Int?
    var period: String?
    var teacher: String?
    var calendarID: String?
    var calendar: EKCalendar?
    var associatedCalendar: EKCalendar?
    var keepInTopShelf = false
    var useSchoolCslendarColour = false
    var isMagdaleneBreak = false
    var isTerm = false
    var isPrelims = false
    var isHidden = false
    var isExam = false
    var EKEvent: EKEvent?
    var notes: String?
    var isAllDay = false
    var isSchoolEvent = false
    var isBirthday = false
    var isDouble = false
    var isUserHideable = false
    var isNicknamed = false
    var source: HLLEventSource!
    var titleReferencesMultipleEvents = false
    var visibilityString: VisibilityString?
    let calc = PercentageCalculator()
    
    #if os(iOS)
    var manualColor: UIColor?
    #endif
    
    var roomChange: String?
    var teacherChange: String?
    
    var usualRoom: String?
    var usualTeacher: String?
    
    var debugForceCountdownString: String?
    var debugForcePercent: String?
    
     var isPinned: Bool = false
    
    var isUserHidden: Bool {
        
        get {
            
            return HLLHiddenEventStore.shared.hiddenEvents.contains(where: {$0.identifier == self.persistentIdentifier})
            
        }
        
    }
    
    var dateInterval: DateInterval {
        
        get {
            
            return DateInterval(start: startDate, end: endDate)
            
            
        }
        
    }
    
    var titleForStatusItem: String? {
        
        get {
            
            var returnValue: String?
            
            if HLLDefaults.statusItem.limitStatusItemTitle {
                let limit = HLLDefaults.statusItem.statusItemTitleLimit
                               
                if limit > 4 {
                    returnValue = self.title.truncated(limit: limit)
                }
                
            } else {
                returnValue = self.title
            }
            
            return returnValue
            
        }
        
    }
    
    #if os(macOS)
    
    var nsColor: NSColor {
        
        get {
            
            var returnColour = NSColor(named: "HLLOrange")!
            
            if let cal = self.associatedCalendar {
                
                returnColour = cal.color
                
            }
            

            
            return returnColour
            
        }
        
        
    }
    
    var color: NSColor {
        
        get {
            
            return nsColor
            
        }
        
    }
    
    #else
    
    var color: UIColor {
        
        get {
            
            return uiColor
            
        }
        
    }
    

    
    var uiColor: UIColor {
        
        get {
 
        
            if let manualColor = manualColor {
                return manualColor
            }
            
            var returnColour = UIColor.black
            
            #if os(iOS)
            
            if #available(iOS 13.0, *) {
                returnColour = UIColor.label
            }
            
            #endif
            
            #if os(watchOS)
                returnColour = UIColor.HLLOrange
            #endif

            if let cal = self.associatedCalendar {
                returnColour = UIColor(cgColor: cal.cgColor)
            }
            
            return returnColour.catalystAdjusted()
            
            
        }
        
        
        
    }
    
    
    #endif
    
    
    var calendarForColour: EKCalendar? {
        
        get {
            
            if let cal = calendar {
                
                    return cal
            
            }
            
            if let cal = associatedCalendar {
                
                return cal
                
            }
            
            return nil
        }
        
    }
    
    var countdownTypeString: String {
        
        get {
        
            var returnText = "end"
            
            if self.completionStatus == .upcoming {
                
                returnText = "start"
            }
            
            
            if !titleReferencesMultipleEvents {
                
                returnText += "s"
                
                
            }
            
            return returnText
            
        }
        
        
    }
    
    
    
    var countdownStringEnd: String {
        
        get {
        
            var returnText = "end"
            
            if !titleReferencesMultipleEvents {
                
                returnText += "s"
                
                
            }
            
            return returnText
            
        }
        
        
    }
    
    var countdownStringStart: String {
        
        get {
        
            var returnText = "start"
            
            if !titleReferencesMultipleEvents {
                
                returnText += "s"
                
                
            }
            
            return returnText
            
        }
        
        
    }
    
    var countdownDate: Date {
        
        get {
            
            if self.completionStatus == .upcoming {
                
                return startDate
                
            } else {
                
                return endDate
                
            }
            
            
        }
        
        
    }
    
    func countdownDate(at: Date) -> Date {
        
        if completionStatus(at: at) == .upcoming {
            return startDate
        }
        
        return endDate
        
    }
    
    var duration: TimeInterval {
        
        get {
            
            return self.endDate.timeIntervalSince(self.startDate)
            
        }
        
    }
    
    var completionPercentage: String {
        
        get {
        
        
            return calc.calculatePercentageDone(for: self)
        
        
        }
    }
    
    var completionFraction: Double {
        
        get {
            
            let secondsElapsed = CurrentDateFetcher.currentDate.timeIntervalSince(self.startDate)
            let totalSeconds = self.endDate.timeIntervalSince(self.startDate)
            return 100*secondsElapsed/totalSeconds
            
        }
    }
    
    var completionStatus: EventCompletionStatus {
        
        get {
            
            return self.completionStatus(at: CurrentDateFetcher.currentDate)
                
        }
            
    }
    
    var isSelected: Bool {
        
        get {
            
            return self.persistentIdentifier == SelectedEventManager.shared.selectedEvent?.persistentIdentifier
            
        }
        
    }
    
    var compactInfoText: String {
        
        get {
            
            var infoText = startDate.formattedTime()
                   
                   if let location = location {
                       
                       infoText = "\(location) | \(infoText)"
                       
                   }
                   
                   if startDate.daysUntil() != 0 {
                       
                       infoText = "\(startDate.getDayOfWeekName(returnTodayIfToday: true)) | \(startDate.formattedTime())"
                       
                   }
            
            return infoText
            
        }
        
    }
    
    var infoIdentifier: String {
        
        get {
            
            let id = "\(originalTitle) \(startDate) \(endDate) \(calendarID ?? "nil") \(location ?? "nil") \(self.isPinned) \(self.title) \(self.isUserHidden)"
            return "\(id)"
            
            
        }
        
    }
    
    var persistentIdentifier: String {
        
        get {
            
            if let ekID = self.EKEvent?.eventIdentifier {
                return ekID
            } else {
                return self.infoIdentifier
            }
            
        }
        
    }
    
    var followingOccurence: HLLEvent? {
        
        get {
            
          return FollowingOccurenceStore.shared.nextOccurDictionary[persistentIdentifier]
            
            
        }
        
        
    }
    
    var hasMagdalenePeriod: Bool {
        
        get {
            
            return self.period != nil
            
        }
        
        
    }
    
    var schoolEventIdentifier: String {
        
        get {
            
            var returnString = ""
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EE"
            returnString = dateFormatter.string(from: self.startDate)

            if Calendar.current.component(.weekOfYear, from: self.startDate) % 2 == 0 {
                returnString += "A"
            } else {
                returnString += "B"
            }
            
            dateFormatter.dateFormat = "HH:mm"
            
            returnString += " \(dateFormatter.string(from: self.startDate))"
            returnString += " \(dateFormatter.string(from: self.endDate))"
            
            return returnString
        }
        
    }
    
    init(event: EKEvent) {
        
        // Init a HLLEvent from an EKEvent.
       // print("Creating event \(event.title)")
        
        self.isUserHideable = true
        
        if let safeTitle = event.title {
        
           
            
            title = safeTitle.components(separatedBy: " (").first!
            
            
        } else {
            
            title = "Nil"
            
        }
        
        
        
        ultraCompactTitle = title
        originalTitle = title
        shortTitle = title.truncated(limit: 25, position: .tail, leader: "...")
        
        
        startDate = event.startDate
        endDate = event.endDate
        notes = event.notes
        isAllDay = event.isAllDay
        EKEvent = event
        
        if let notes = event.notes {
            if notes.contains(text: "Attending Staff :") {
                isSchoolEvent = true
                
            }
        }
        
        if var loc = event.location, loc != "" {
            
            if isSchoolEvent {
                loc = "Room: \(loc)"
            }
            
            
            if HLLDefaults.general.showLocation {
                location = loc
                
       
                
                let truncatedLocation = loc.truncated(limit: 15, position: .tail, leader: "...")
                
                shortLocation = truncatedLocation
                
            }
            fullLocation = loc
            
            
            
        }
        
        if let cal = event.calendar {
            
            calendarID = cal.calendarIdentifier
            calendar = cal
            associatedCalendar = cal
            
        }
        
        
        
        isBirthday = event.birthdayContactIdentifier != nil
            
        
    }
    
    
    init(title inputTitle: String, start inputStart: Date, end inputEnd: Date, location inputLocation: String?) {
        
        // Init a HLLEvent from custom data.
        
        self.isUserHideable = false
        title = inputTitle
        originalTitle = inputTitle
        ultraCompactTitle = inputTitle
        shortTitle = inputTitle
        startDate = inputStart
        endDate = inputEnd
        
        if let loc = inputLocation, loc != "" {
            
            if HLLDefaults.general.showLocation {
                location = loc
            }
            fullLocation = loc
            
        }
        
    }
    
    func truncatedTitle(_ limit: Int = 20) -> String {
        
        return title.truncated(limit: limit, position: .middle, leader: "...")
        
        
    }
    
    func completionStatus(at: Date) -> EventCompletionStatus {
        
        if self.startDate.timeIntervalSince(at) > 0 {
            return .upcoming
        } else if self.endDate.timeIntervalSince(at) < 0 {
            return .done
        } else {
            return .current
        }
        
    }
    
     func getUpdatedInstance() -> HLLEvent? {
        
        var returnValue: HLLEvent?
        
        var id = self.persistentIdentifier
        
        if let eventID = self.EKEvent?.eventIdentifier {
            id = eventID
        }
        
        if let event = HLLEventSource.shared.findEventWithIdentifier(id: id) {
                
            returnValue = event 
                
        }
            
        
        return returnValue
        
    }
    
    static func == (lhs: HLLEvent, rhs: HLLEvent) -> Bool {
        
        return lhs.infoIdentifier == rhs.infoIdentifier && lhs.completionStatus == rhs.completionStatus
        
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(infoIdentifier)
    }
    
    static func previewEvent() -> HLLEvent {
        
        let event = HLLEvent(title: "Preview", start: Date(), end: Date().addingTimeInterval(45*60), location: nil)
        return event
        
    }
    
}
