//
//  HLLEvent.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 2/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit
import UIKit

class HLLEvent: EventUIObject, Equatable, Hashable, Codable, Identifiable {
    
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
    
    var color: UIColor { UIColor(cgColor: calendar?.cgColor ?? UIColor.HLLOrange.cgColor) }
    
    var countdownDate: Date { countdownDate() }
    
    var completionStatus: CompletionStatus { completionStatus() }
    
    var completionPercentage: String { PercentageCalculator().calculatePercentageDone(for: self) }
    
    var completionFraction: Double { return completionFraction() }
    
    var persistentIdentifier: String { eventIdentifier ?? infoIdentifier }
    
    var duration: TimeInterval { endDate.timeIntervalSince(startDate) }
    
    var isSelected: Bool { SelectedEventManager.shared.selectedEvent == self }
    
    var isPinned: Bool { HLLDefaults.general.pinnedEventIdentifiers.contains(where: { $0 == persistentIdentifier } ) }
    
    var countdownTypeString: String { countdownTypeString() }
    
    var infoIdentifier: String { "\(title) \(startDate) \(endDate) \(calendarID ?? "nil") \(location ?? "nil")" }
    
    var id: String { persistentIdentifier }
    
    init(_ event: EKEvent) {
        title = event.title
        originalTitle = event.title
        startDate = event.startDate
        endDate = event.endDate
        isAllDay = event.isAllDay
        location = event.location
        calendarID = event.calendar?.calendarIdentifier
        eventIdentifier = event.eventIdentifier
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
        
        if startDate.timeIntervalSince(date) > 0 {
            return .upcoming
        } else if endDate.timeIntervalSince(date) <= 0 {
            return .done
        } else {
            return .current
        }
        
    }
    
    func completionFraction(at date: Date = Date()) -> Double {
        return date.timeIntervalSince(startDate)/endDate.timeIntervalSince(startDate)
    }
    
    func countdownDate(at: Date = Date()) -> Date { completionStatus() == .upcoming ? startDate : endDate }
    
    func countdownTypeString(at date: Date = Date()) -> String {
        completionStatus(at: date) == .upcoming ? "starts" : "ends"
    }
    
    func truncatedTitle(_ limit: Int = 20) -> String {
        return title.truncated(limit: limit, position: .middle, leader: "...")
    }
    
    static func == (lhs: HLLEvent, rhs: HLLEvent) -> Bool {
        lhs.infoIdentifier == rhs.infoIdentifier && lhs.completionStatus == rhs.completionStatus
    }
    
    static func previewEvent() -> HLLEvent {
        HLLEvent(title: "Preview", start: Date(), end: Date().addingTimeInterval(45*60), location: nil)
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
    
    var color: UIColor { get }
    
    var id: String { get }
    
    var completionStatus: HLLEvent.CompletionStatus { get }
    
    func completionStatus(at date: Date) -> HLLEvent.CompletionStatus
    
    var countdownTypeString: String { get }
    
    var countdownDate: Date { get }
    
    func countdownDate(at: Date) -> Date
    
    func countdownTypeString(at date: Date) -> String
    
}

class PreviewEvent: EventUIObject {
    
    internal init(title: String, startDate: Date, endDate: Date, color: UIColor, completionStatus: HLLEvent.CompletionStatus) {
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
    
    var color: UIColor
    
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
    
    static func inProgressPreviewEvent(title: String = "Event", minsStartedAgo: Int = 10, minsEndingIn: Int = 25, color: UIColor = .orange) -> PreviewEvent {
        
        return PreviewEvent(title: title, startDate: (Date() - TimeInterval(minsStartedAgo*60)), endDate: Date().addingTimeInterval(TimeInterval(minsEndingIn*60)), color: color, completionStatus: .current)
        
    }
    
    static func upcomingPreviewEvent(title: String = "Event", minsStartingIn: Int = 25, color: UIColor = .orange) -> PreviewEvent {
        
        return PreviewEvent(title: title, startDate: Date().addingTimeInterval(TimeInterval(minsStartingIn*60)), endDate: Date.distantFuture, color: color, completionStatus: .upcoming)
        
    }
    
    
}
