//
//  ComplicationDataStatusHandler.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 18/4/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation

class ComplicationDataStatusHandler {
    
    static var shared = ComplicationDataStatusHandler()
    let dataSource = EventDataSource()
    
    func didComplicationUpdate() {
        
        HLLDefaults.defaults.set(generateDataString(), forKey: "ComplicationUpdateData")
        
    }
    
    func complicationIsUpToDate() -> Bool {
        
        if SchoolAnalyser.privSchoolMode != .Magdalene {
        
        if HLLDefaults.defaults.bool(forKey: "ComplicationPurchased") != HLLDefaults.defaults.bool(forKey: "UpdatedWithEvents") {
            
            return false
            
        }
        
        }
        
        if let data = HLLDefaults.defaults.string(forKey: "ComplicationUpdateData") {
            
            if data == generateDataString() {
                
                return true
                
            } else {
                
                return false
                
            }
            
            
            
        } else {
            
            return false
            
        }
        
        
    }
    
    private func generateDataString() -> String {
        
        let dataSource = EventDataSource()
        var events = dataSource.fetchEventsFromPresetPeriod(period: .AllTodayPlus24HoursFromNow)
        events.append(contentsOf: dataSource.fetchEventsFromPresetPeriod(period: .Next2Weeks))
        return "\(Version.currentVersion)\(Version.buildVersion)\(events.map { $0.identifier }.joined())"
        
    }
    
    
}
