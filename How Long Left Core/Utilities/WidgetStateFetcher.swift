//
//  WidgetStateFetcher.swift
//  How Long Left
//
//  Created by Ryan Kontos on 2/12/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class WidgetStateFetcher {
    
    func getWidgetState() -> TimelineState {
        
        if HLLDefaults.appData.migratedCoreData == false {
            return .notMigrated
        }
        
        
        #if os(macOS)
        
        if ProStatusManager.shared.isPro == false {
            return .notPurchased
        }
        
        #endif
        
        if HLLEventSource.shared.access != .Granted {
            
            return .noCalendarAccess
            
        }
        
        return .normal
        
    }

}
