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

class HLLEvent: Equatable, Hashable, Codable, Identifiable {
    
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
    
    var color: UIColor { UIColor(cgColor: calendar?.cgColor ?? UIColor.orange.cgColor) }
    
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
