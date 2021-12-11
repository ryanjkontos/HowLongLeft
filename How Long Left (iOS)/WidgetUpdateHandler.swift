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
    
    let difHander = HLLTimelineDifHandler()
    let widgetStateFetcher = WidgetStateFetcher()
    
    static var shared: WidgetUpdateHandler!
    
    let timelineGen = HLLTimelineGenerator(type: .widget)
    
    init() {
        
        
        HLLEventSource.shared.addEventPoolObserver(self, immediatelyNotify: true)
        updateWidget()
        
    }
    
    func updateWidget(force: Bool = false) {

        print("Checking widget update!")
        
        if #available(OSX 11, *) {
        
        
        
        let timeline = timelineGen.generateTimelineItems(fast: false, forState: widgetStateFetcher.getWidgetState())
        
        if difHander.shouldUpdateTo(newtimeline: timeline) || force == true {
        
            print("Reloading Widgets...")
            WidgetCenter.shared.reloadAllTimelines()
            
        } else {
            print("Not updating widget")
        }
            
        } else {
            print("Not upcoming widget bc os version")
        }
        
    }
    
    func eventPoolUpdated() {
        updateWidget()
        
    }
    
}
