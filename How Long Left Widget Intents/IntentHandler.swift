//
//  IntentHandler.swift
//  How Long Left Widget Intents
//
//  Created by Ryan Kontos on 17/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Intents


class IntentHandler: INExtension, HLLWidgetConfigurationIntentHandling {

    let store = WidgetConfigurationStore()

    override init() {
        
        super.init()
        
        HLLEventSource.shared.updateEventPool()
        
    }
    
    func provideConfigOptionsCollection(for intent: HLLWidgetConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetConfigType>?, Error?) -> Void) {
        
        let defaultItem = WidgetConfigType(identifier: store.defaultGroup.id, display: "Default Configuration")
        let defaultSection = INObjectSection(title: nil, items: [defaultItem])
        
        var customArray = [WidgetConfigType]()
        for object in store.customGroups {
            
            if let searchTerm = searchTerm {
                if !object.name.lowercased().contains(searchTerm.lowercased()) { continue }
            }
            
            customArray.append(WidgetConfigType(identifier: object.id, display: object.name))
        }
        
        let customSection = INObjectSection(title: searchTerm == nil ? "Custom" : nil, items: customArray)
    
       
        var collection = INObjectCollection(sections: [defaultSection, customSection])
        
        if searchTerm != nil {
            collection = INObjectCollection(sections: [customSection])
        }
        
        
        
      completion(collection, nil)
        
    }
    
    func defaultConfig(for intent: HLLWidgetConfigurationIntent) -> WidgetConfigType? {
        
        let defaultItem = WidgetConfigType(identifier: store.defaultGroup.id, display: "Default Configuration")
        
        return defaultItem
        
    }
    
    func provideEnabledEventsOptionsCollection(for intent: HLLWidgetConfigurationIntent, searchTerm: String?, with completion: @escaping (INObjectCollection<WidgetEvent>?, Error?) -> Void) {
        
        let events = HLLEventSource.shared.eventPool
        
        var items = [WidgetEvent]()
        
        for event in events {
            
            if let searchTerm = searchTerm {
                if !event.title.lowercased().contains(searchTerm.lowercased()) { continue }
            }
            
            let item = WidgetEvent(identifier: event.id, display: event.title)
            item.subtitleString = "\(event.startDate.userFriendlyRelativeString()), \(event.startDate.formattedTime()) - \(event.endDate.userFriendlyRelativeString()), \(event.endDate.formattedTime())"
            items.append(item)
            
        }
        
        
        let collection = INObjectCollection(items: items)
        
        completion(collection, nil)
        
    }
    
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
}
