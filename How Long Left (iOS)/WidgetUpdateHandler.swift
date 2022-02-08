//
//  WidgetUpdateHandler.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 17/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
#if canImport(WidgetKit)
import WidgetKit
#endif

class WidgetUpdateHandler: EventPoolUpdateObserver {
    
    
    let widgetStateFetcher = WidgetStateFetcher()
    
    static var shared: WidgetUpdateHandler = WidgetUpdateHandler()
    
    let timelineGen = HLLTimelineGenerator(type: .widget)
    
    init() {
        
        
        HLLEventSource.shared.addEventPoolObserver(self, immediatelyNotify: true)
        updateWidget()
        
    }
    
    func updateWidget(force: Bool = false, background: Bool = false) {

        
        print("Checking widget update!")
   
            if timelineGen.shouldUpdate() == .needsReloading || force == true {
        
            print("Reloading Widgets...")
                
                if background {
                    let count = HLLDefaults.defaults.integer(forKey: "BGCausedWidgetUpdateCount")+1
                    HLLDefaults.defaults.set(count, forKey: "BGCausedWidgetUpdateCount")
                }
                
                WidgetCenter.shared.reloadAllTimelines()
            
        } else {
            print("Not updating widget")
        }
            
        
        
    }
    
    func eventPoolUpdated() {
        updateWidget()
        
    }
    
}
