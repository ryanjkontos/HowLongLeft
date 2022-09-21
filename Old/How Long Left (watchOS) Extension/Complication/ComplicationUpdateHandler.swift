//
//  ComplicationDataStatusHandler.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 18/4/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class ComplicationUpdateHandler: EventPoolUpdateObserver, DefaultsTransferObserver {
    
    static var shared = ComplicationUpdateHandler()
    
    init() {
        HLLEventSource.shared.addEventPoolObserver(self)
        HLLDefaultsTransfer.shared.addTransferObserver(self)
    }
    
    func eventPoolUpdated() {
        updateComplication()
    }
    
    
    func updateComplication(force: Bool = false) {
        
        if HLLDefaults.complication.complicationPurchased == false, force == false {
            return
        }
        
        DispatchQueue.global(qos: .default).async {
        
        if let entries = CLKComplicationServer.sharedInstance().activeComplications {
            
             if ComplicationUpdateHandler.shared.complicationIsUpToDate() == false || force {
                
                if HLLEventSource.shared.neverUpdatedEventPool {
                                   HLLEventSource.shared.updateEventPool()
                    }
                               
                
            for complicationItem in entries  {
                
               
                CLKComplicationServer.sharedInstance().reloadTimeline(for: complicationItem)
                
            }
        }
        
        }
            
        }
        
    }
    
    func didComplicationUpdate() {
        
        HLLDefaults.defaults.set(generateDataString(), forKey: "ComplicationUpdateData")
        
    }
    
    func complicationIsUpToDate() -> Bool {
        
        if HLLDefaults.complication.complicationEnabled != HLLDefaults.defaults.bool(forKey: "UpdatedWithEvents") {
            
            return false
            
        }
        
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
        
        let events = HLLEventSource.shared.eventPool
        return "\(Version.currentVersion)\(Version.buildVersion)\(events.map { $0.persistentIdentifier }.joined())"
        
    }
    
    func defaultsUpdated() {
        updateComplication(force: true)
    }
    
    
}
