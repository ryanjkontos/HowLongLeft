//
//  HLLEvent.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 2/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit
#if canImport(UIKit)
import UIKit
typealias SystemColor = UIColor
#elseif canImport(AppKit)
import AppKit
typealias SystemColor = NSColor
#endif



struct HLLEvent: EventUIObject, Equatable, Hashable, Codable, Identifiable {
    
    var title: String
    
    var originalTitle: String
    
    var startDate: Date
    
    var endDate: Date
    
    var isAllDay: Bool
    
    var location: String?
    
    var calendarID: String?
    
    var eventIdentifier: String?
    
    var isUserHideable = false
    
    var isNicknamed = false
    
    var calendar: EKCalendar? { HLLEventSource.shared.calendarFromID(calendarID) }
    
    var ekEvent: EKEvent? { HLLEventSource.shared.ekEvent(with: eventIdentifier) }
    
    var color: SystemColor { calendar?.getColor() ?? .orange }
    
    var countdownDate: Date { countdownDate() }
    
    var completionStatus: CompletionStatus { completionStatus() }
    
    var completionPercentage: String { PercentageCalculator().calculatePercentageDone(for: self) }
    
    var completionFraction: Double { return completionFraction() }
    
    var persistentIdentifier: String { eventIdentifier ?? infoIdentifier }
    
    var duration: TimeInterval { endDate.timeIntervalSince(startDate) }
    
    var isSelected: Bool { SelectedEventManager.shared.selectedEvent == self }
    
    var isPinned: Bool {
        //HLLDefaults.general.pinnedEventIdentifiers.contains(where: { $0 == persistentIdentifier})
        HLLStoredEventManager.shared.isPinned(event: self)
    }
    
    var countdownTypeString: String { countdownTypeString() }
    
    var followingOccurence: HLLEvent? { FollowingOccurenceStore.shared.nextOccurDictionary[persistentIdentifier] }
    
    var infoIdentifier: String { "\(originalTitle) \(startDate) \(endDate) \(calendarID ?? "nil") \(location ?? "nil")" }
    
    var id: String { infoIdentifier }
    
    init(_ event: EKEvent) {
        title = event.title
        originalTitle = event.title
        startDate = event.startDate
        endDate = event.endDate
        isAllDay = event.isAllDay
        location = event.location
        calendarID = event.calendar?.calendarIdentifier
        if event.hasRecurrenceRules == false {
            eventIdentifier = event.eventIdentifier
        }
    }
    
    init(title inputTitle: String, start inputStart: Date, end inputEnd: Date, location inputLocation: String?) {
        title = inputTitle
        originalTitle = inputTitle
        startDate = inputStart
        endDate = inputEnd
        isAllDay = false
        if let loc = inputLocation, loc != "" {
            if HLLDefaults.general.showLocation { location = loc }
        }
    }
    
    func completionStatus(at date: Date = Date()) -> CompletionStatus {
        
        
        let endInterval = endDate.timeIntervalSince(date)
        if startDate.timeIntervalSince(date) > 0 {
            return .upcoming
        } else if endInterval <= 0 {
            return .done
        } else {
            return .current
        }
        
    }
    
    func completionFraction(at date: Date = Date()) -> Double {
        let v = date.timeIntervalSince(startDate)/endDate.timeIntervalSince(startDate)
        if v < 0 { return 0 }
        if v > 1 { return 1 }
        return v
    }
    
    func countdownDate(at: Date = Date()) -> Date { completionStatus(at: at) == .upcoming ? startDate : endDate }
    
    func countdownTypeString(at date: Date = Date()) -> String {
        switch completionStatus(at: date) {
            
        case .upcoming:
            return "starts in"
        case .current:
            return "ends in"
        case .done:
            return "ends in"
        }
        
    }
    
    func truncatedTitle(_ limit: Int = 20) -> String {
        return title.truncated(limit: limit, position: .middle, leader: "...")
    }
    
    static func previewEvent() -> HLLEvent {
        HLLEvent(title: "Preview", start: Date(), end: Date().addingTimeInterval(45*60), location: nil)
    }
    
    static func previewUpcomingEvent() -> HLLEvent {
        HLLEvent(title: "Upcoming", start: Date().addingTimeInterval(600), end: Date().addingTimeInterval(45*60), location: nil)
    }
    
    var userActivity: NSUserActivity {
        let userActivity = NSUserActivity(activityType: UserActivity.viewEventKey)
        userActivity.userInfo = ["EventID": persistentIdentifier]
        userActivity.targetContentIdentifier = persistentIdentifier
        return userActivity
    }
    
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    
    func getUpdatedInstance() -> HLLEvent? {
        var returnValue: HLLEvent?
        var id = persistentIdentifier
        if let eventID = eventIdentifier { id = eventID }
        if let event = HLLEventSource.shared.findEventWithIdentifier(id: id) {
            returnValue = event
        }
        return returnValue
    }
    
    enum CompletionStatus {
        case upcoming
        case current
        case done
    }

}

protocol EventUIObject {
    
    var title: String { get }
    
    var startDate: Date { get }
    
    var endDate: Date { get }
    
    var color: SystemColor { get }
    
    var location: String? { get }
    
    var id: String { get }
    
    var completionStatus: HLLEvent.CompletionStatus { get }
    
    func completionStatus(at date: Date) -> HLLEvent.CompletionStatus
    
    var countdownTypeString: String { get }
    
    var countdownDate: Date { get }
    
    func countdownDate(at: Date) -> Date
    
    func countdownTypeString(at date: Date) -> String
    
}

class PreviewEvent: EventUIObject {
    
    internal init(title: String, startDate: Date, endDate: Date, color: SystemColor, completionStatus: HLLEvent.CompletionStatus, location: String? = nil) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
        self.completionStatus = completionStatus
        self.id = UUID().uuidString
    }
    
    
    var title: String
    
    var startDate: Date
    
    var endDate: Date
    
    var location: String?
    
    var color: SystemColor
    
    var id: String
    
    var completionStatus: HLLEvent.CompletionStatus
    
    var countdownTypeString: String { countdownTypeString() }
    
    var countdownDate: Date { countdownDate() }
    
    func countdownDate(at: Date = Date()) -> Date { self.completionStatus() == HLLEvent.CompletionStatus.upcoming ? startDate : endDate }
    
    func countdownTypeString(at date: Date = Date()) -> String {
        completionStatus(at: date) == .upcoming ? "starts" : "ends"
    }
    
    func completionStatus(at date: Date = Date()) -> HLLEvent.CompletionStatus {
        return completionStatus
    }
    
    func completionFraction(at date: Date = Date()) -> Double {
        return date.timeIntervalSince(startDate)/endDate.timeIntervalSince(startDate)
    }
    
    static func inProgressPreviewEvent(title: String = "Event", minsStartedAgo: Int = 10, minsEndingIn: Int = 25, color: SystemColor = .orange) -> PreviewEvent {
        
        return PreviewEvent(title: title, startDate: (Date() - TimeInterval(minsStartedAgo*60)), endDate: Date().addingTimeInterval(TimeInterval(minsEndingIn*60)), color: color, completionStatus: .current)
        
    }
    
    static func upcomingPreviewEvent(title: String = "Event", minsStartingIn: Int = 25, color: SystemColor = .orange) -> PreviewEvent {
        
        return PreviewEvent(title: title, startDate: Date().addingTimeInterval(TimeInterval(minsStartingIn*60)), endDate: Date.distantFuture, color: color, completionStatus: .upcoming)
        
    }
    
   
    
    
}

extension EKCalendar {
    
    func getColor() -> SystemColor {
        #if os(macOS)
        return self.color
        #else
        return UIColor(cgColor: self.cgColor)
        #endif
        
        
    }
    
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
