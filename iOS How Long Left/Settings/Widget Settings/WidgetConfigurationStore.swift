//
//  WidgetConfigurationStore.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

@available(macOS 10.15, *)
class WidgetConfigurationStore: ObservableObject {

    static var defaultsKey = "WidgetConfigurationsbee"
    
    var defaultGroup: HLLTimelineConfiguration! { didSet { saveFromCurrentArray() } }
    var customGroups = [HLLTimelineConfiguration]() { didSet { saveFromCurrentArray() } }
    
    var allGroups: [HLLTimelineConfiguration] {
        get {
            var allGroups = customGroups
            allGroups.append(defaultGroup)
            return allGroups
        }
    }
    
    init() {
        loadGroups()
    }
    
    func getConfigFromIntent(intent: WidgetConfigType) -> HLLTimelineConfiguration? {
        
        loadGroups()
        
        return allGroups.first(where: ( { $0.id == intent.identifier } ))
        
    }
    
    func createCustomNewGroup() -> HLLTimelineConfiguration {
        
        let group = HLLTimelineConfiguration(creationDate: Date(), groupType: .customGroup)
        return group
    }
    
    func loadGroups() {
        
        var tempNamedGroups = [HLLTimelineConfiguration]()
        if let groupDict = HLLDefaults.defaults.dictionary(forKey: WidgetConfigurationStore.defaultsKey) as? [String:Data] {
            for groupData in groupDict.values {
                let group = decodeGroup(groupData)
                switch group.groupType {
                    case .defaultGroup:
                        defaultGroup = group
                    case .customGroup:
                        tempNamedGroups.append(group)
                }
            }
        } else {
            // print("Creating default group")
            defaultGroup = getNewDefaultGroup()
            saveGroups(allGroups)
        }
        
        if defaultGroup == nil {
            defaultGroup = getNewDefaultGroup()
        }
        
        customGroups = tempNamedGroups.sorted(by: { $0.creationDate.compare($1.creationDate) == .orderedAscending })
        
        self.objectWillChange.send()
        
    }
    
    func saveGroup(_ group: HLLTimelineConfiguration) {
        
        var g = allGroups
        g.removeAll(where: { $0.id == group.id })
        g.append(group)
        saveGroups(g)
        loadGroups()
        
    }
    
    func deleteGroup(_ group: HLLTimelineConfiguration) {
        
        var g = allGroups
        g.removeAll(where: { $0.id == group.id })
        saveGroups(g)
        loadGroups()
        
        
    }
    
    func saveFromCurrentArray() {
        saveGroups(allGroups)
    }
    
    private func saveGroups(_ newGroups: [HLLTimelineConfiguration]) {
        
        var dict = [String:Data]()
        for group in newGroups {
            dict[group.id] = encodeGroup(group)
        }
        HLLDefaults.defaults.set(dict, forKey: WidgetConfigurationStore.defaultsKey)
        
    }

    
    private func getNewDefaultGroup() -> HLLTimelineConfiguration {
        
        let group = HLLTimelineConfiguration(name: "Default Configuration", creationDate: Date(), groupType: .defaultGroup)
        return group
    }
    
    
    func encodeGroup(_ group: HLLTimelineConfiguration) -> Data {
        
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(group)
        return encoded
        
    }
    
    func decodeGroup(_ data: Data) -> HLLTimelineConfiguration {
        
        let decoder = JSONDecoder()
        let decoded = try! decoder.decode(HLLTimelineConfiguration.self, from: data)
        return decoded
        
    }
    
    
}

