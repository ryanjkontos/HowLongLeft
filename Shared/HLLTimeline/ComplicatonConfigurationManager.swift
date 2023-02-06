//
//  ComplicatonConfigurationManager.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 19/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class ComplicatonConfigurationManager {
    
    private let key = "ComplicationConfiguration"
    
    func getConfig() -> HLLTimelineConfiguration {
        
        if HLLDefaults.defaults.data(forKey: key) == nil { resetConfig() }
        let data = HLLDefaults.defaults.data(forKey: key)!
        if let decoded = try? JSONDecoder().decode(HLLTimelineConfiguration.self, from: data) {
            return decoded
        }
        
        resetConfig()
        return getConfig()
        
    }
    
    func saveConfig(_ config: HLLTimelineConfiguration) {
        
        let encoded = try! JSONEncoder().encode(config)
        HLLDefaults.defaults.set(encoded, forKey: key)
        
    }
 
    private func resetConfig() {
        
        let newConfig = HLLTimelineConfiguration(creationDate: Date(), groupType: .defaultGroup)
        let encoded = try! JSONEncoder().encode(newConfig)
        HLLDefaults.defaults.set(encoded, forKey: key)
        
    }
    
}
