//
//  NotificationGroupsStore.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 13/12/2021.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import WidgetKit

// MARK: NotificationGroupStore
class NotificationGroupStore: ObservableObject {

    static var defaultsKey = "NotificationGroups"
    
    @Published var defaultGroup: NotificationGroup! { didSet { saveFromCurrentArray() } }
    @Published var eventGroups = [NotificationGroup]() { didSet { saveFromCurrentArray() } }
    @Published var namedGroups = [NotificationGroup]() { didSet { saveFromCurrentArray() } }
    
    var allGroups: [NotificationGroup] {
        get {
            var allGroups = eventGroups
            allGroups.append(contentsOf: namedGroups)
            allGroups.append(defaultGroup)
            return allGroups
        }
    }
    
    init() {
        loadGroups()
    }
    
    func createNamedNewGroup() -> NotificationGroup {
        
        let group = NotificationGroup(creationDate: Date(), groupType: .customGroup)
        return group
    }
    
    func loadGroups() {
        
        var tempEventGroups = [NotificationGroup]()
        var tempNamedGroups = [NotificationGroup]()
        if let groupDict = HLLDefaults.defaults.dictionary(forKey: NotificationGroupStore.defaultsKey) as? [String:Data] {
            for groupData in groupDict.values {
                let group = decodeGroup(groupData)
                switch group.groupType {
                    case .defaultGroup:
                        defaultGroup = group
                    case .eventGroup:
                        tempEventGroups.append(group)
                    case .customGroup:
                        tempNamedGroups.append(group)
                }
            }
        } else {
            // print("Creating default group")
            defaultGroup = getNewDefaultGroup()
            saveGroups(allGroups)
        }
        namedGroups = tempNamedGroups.sorted(by: { $0.creationDate.compare($1.creationDate) == .orderedAscending })
        eventGroups = tempEventGroups
        
        
        for group in allGroups {
            // print("Group: \(group.name ?? "Nil")")
        }
        
        
    }
    
    func saveGroup(_ group: NotificationGroup) {
        
        // print("Saving group \(group.name ?? "with no name"), S: \(group.startTrigger  )")
        
        var g = allGroups
        g.removeAll(where: { $0.id == group.id })
        g.append(group)
        saveGroups(g)
        loadGroups()
        
    }
    
    func deleteGroup(_ group: NotificationGroup) {
        
        var g = allGroups
        g.removeAll(where: { $0.id == group.id })
        saveGroups(g)
        loadGroups()
        
        
    }
    
    func saveFromCurrentArray() {
        saveGroups(allGroups)
    }
    
    private func saveGroups(_ newGroups: [NotificationGroup]) {
        
        var dict = [String:Data]()
        for group in newGroups {
            dict[group.id] = encodeGroup(group)
        }
        HLLDefaults.defaults.set(dict, forKey: NotificationGroupStore.defaultsKey)
        
    }

    
    func getNewDefaultGroup() -> NotificationGroup {
        
        let group = NotificationGroup(creationDate: Date(), groupType: .defaultGroup)
        return group
    }
    
    
    func encodeGroup(_ group: NotificationGroup) -> Data {
        
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(group)
        return encoded
        
    }
    
    func decodeGroup(_ data: Data) -> NotificationGroup {
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(NotificationGroup.self, from: data)
        return decoded
        
    }
    
    
}

// MARK: NotificationGroup

struct NotificationGroup: Equatable, Hashable, Codable, Identifiable {
    
    init(creationDate: Date, groupType: NotificationGroupType) {
        
        self.creationDate = creationDate
        self.groupType = groupType
        
        startTrigger = false
        endTrigger = false
        
    }
    
    var triggers = [NotificationTrigger]()
    
    var startsInTriggers: [NotificationTrigger] {
        get {
            return triggers.filter({$0.type == .timeUntil})
        }
    }
    
    var endsInTriggers: [NotificationTrigger] {
        get {
            return triggers.filter({$0.type == .timeRemaining})
        }
    }
    
    var percentageTriggers: [NotificationTrigger] {
        get {
            return triggers.filter({$0.type == .percentage})
        }
    }
    
    var startTrigger: Bool
    var endTrigger: Bool
    var creationDate: Date
    var groupType: NotificationGroupType
    
   
     var name: String?
    
    var eventID: String?
    
    
    var id: String {
        get {
            
            switch groupType {
                case .defaultGroup:
                    return "Default"
                case .eventGroup:
                    return eventID!
                case .customGroup:
                    return String(creationDate.timeIntervalSinceReferenceDate)
            }
            
        }
    }
    
    
    static func == (lhs: NotificationGroup, rhs: NotificationGroup) -> Bool {
            return lhs.id == rhs.id
    }
    
    mutating func removeTrigger(_ trigger: NotificationTrigger) throws {
        
        let count = triggers.count
        triggers.removeAll(where: { $0 == trigger })
        if triggers.count == count {
            throw EditTriggerError.triggerNotFound
        }
        
    }
    
    mutating func newTrigger(_ type: NotificationTrigger.TriggerType, value: Int, id: UUID? = nil) throws {
        
        var value = value
        
        switch type {
            case .timeUntil:
                value = value*60
                if value < 0 { throw EditTriggerError.valueTooLow }
            case .timeRemaining:
                value = value*60
                if value < 0 { throw EditTriggerError.valueTooLow }
            case .percentage:
                if value == 0 { throw EditTriggerError.useStart }
                if value == 100 { throw EditTriggerError.useEnd }
                if value < 0 { throw EditTriggerError.valueTooLow }
                if value > 100 { throw EditTriggerError.valueTooHigh }
        }
        
        if !triggers.contains(where: {  $0.value == value && $0.type == type}) {
            triggers.append(NotificationTrigger(id: id ?? UUID(), type: type, value: value))
        } else {
            throw EditTriggerError.duplicate
        }
        
    }
    
    mutating func editTrigger(_ trigger: NotificationTrigger, newValue: Int) throws {
        
        let id = trigger.id
        let type = trigger.type
        
        try removeTrigger(trigger)
        try newTrigger(type, value: newValue, id: id)
        
    }
    
    static func sampleGroup() -> NotificationGroup {
        
        let group = NotificationGroup(creationDate: Date(), groupType: .customGroup)
        
        return group
        
    }
    

    
    static func newNamedGroup() -> NotificationGroup {
        
        return NotificationGroup(creationDate: Date(), groupType: NotificationGroupType.customGroup)
        
    }

}

enum NotificationGroupType: Codable {
    
    case defaultGroup
    case eventGroup
    case customGroup
    
}

// MARK: NotificationTrigger
struct NotificationTrigger: Equatable, Hashable, Codable, Identifiable {
    
    var id: UUID
    
    var type: TriggerType
    var value = 0
    
    
    enum TriggerType: String, Codable, CaseIterable {
        
        case timeUntil
        case timeRemaining
        case percentage
        
      

    }
    
    static func createTrigger(type: TriggerType) -> NotificationTrigger {
        
        let trigger = NotificationTrigger(id: UUID(), type: type, value: 0)
        return trigger
    }
    
}

enum EditTriggerError: LocalizedError {
    case duplicate
    case useStart
    case useEnd
    case valueTooHigh
    case valueTooLow
    case triggerNotFound
    
    public var errorDescription: String? {
            
        switch self {
        case .duplicate:
            return "Already exsits"
        case .useStart:
            return "Use start"
        case .useEnd:
            return "Use end"
        case .valueTooHigh:
            return "Too high"
        case .valueTooLow:
            return "Too low"
        case .triggerNotFound:
            return "This trigger could not be edited because it does not exist"
        }
        
    }
    
    public var failureReason: String? {
        
        return "Reason"
        
    }
    
    public var recoverySuggestion: String? {
        
        return "Suggestion"
        
    }
    
    public var helpAnchor: String? {
        
        return "Help"
        
    }
    
}
