//
//  ThirdRowSettingsManager.swift
//  How Long Left watch App WatchKit Extension
//
//  Created by Ryan Kontos on 3/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation

extension HLLDefaults.complication {
    
    private static var thirdRowKey = "ComplicationThirdRowMode"
    private static var altThirdRowKey = "AltComplicationThirdRowMode"
    private static var progressBarKey = "RectComplicationNoProgressBars"
    
    static var mainThirdRowMode: ThirdRowMode {
        
        get {
            guard let value = HLLDefaults.defaults.string(forKey: thirdRowKey) else { return .nextEvent }
            return ThirdRowMode(rawValue: value) ?? .nextEvent
        }
        
        set { HLLDefaults.defaults.set(newValue.rawValue, forKey: thirdRowKey) }
        
    }
    
    static var alternateThirdRowMode: ThirdRowMode? {
        
        get {
            guard let value = HLLDefaults.defaults.string(forKey: altThirdRowKey) else { return nil }
            return ThirdRowMode(rawValue: value) ?? .nextEvent
        }
        
        set { HLLDefaults.defaults.set(newValue?.rawValue, forKey: altThirdRowKey) }
        
    }
    
    static var progressBar: Bool {
        
        get {
            return !HLLDefaults.defaults.bool(forKey: progressBarKey)
        }
        
        set { HLLDefaults.defaults.set(!newValue, forKey: progressBarKey) }
        
    }
    
    
}

    enum ThirdRowMode: String {
    
        case nextEvent = "NextEvent"
        case location = "Location"
        case time = "Time"
    
    }



