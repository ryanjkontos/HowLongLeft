//
//  StatusItemUpdateHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 7/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class HLLStatusItemContentGenerator {
   
    
    var event: HLLEvent?
    

    var configuration: HLLStatusItemConfiguration
    
    init(configuration: HLLStatusItemConfiguration) {
        self.configuration = configuration
        self.event = configuration.eventRetriver.retrieveEvent()
    }
    
    func getStatusItemContent() -> HLLStatusItemContent {
        
        var returnContent: HLLStatusItemContent
    
        if CalendarReader.shared.calendarAccess == .Denied {
            var content = HLLStatusItemContent()
            content.text = "⚠️"
            return content
        }
        
        if let event = self.event {
            returnContent = generateEventCountdownContent(for: event)
        } else {
            returnContent = generateNoEventContent(config: configuration)
        }
        
        if HLLDefaults.statusItem.mode == .Off  {
            returnContent = generateNoEventContent(config: configuration, inactive: true)
        }
        
        return returnContent
        
    }
    
    func updateEvent() {
        
        self.event = configuration.eventRetriver.retrieveEvent()
        
    }
    
    func generateNoEventContent(config: HLLStatusItemConfiguration, inactive: Bool = false) -> HLLStatusItemContent {
        
        var content = HLLStatusItemContent()
        
        content.meaningfulData = false
        
        if inactive {
            content.alpha = StatusItemGlobals.inactiveAlpha
        }
        
        switch config.type {
            
        case .main:
            content.image = StatusItemGlobals.currentIcon
        case .event:
            content.alpha = StatusItemGlobals.inactiveAlpha
            if let event = config.eventRetriver.retrieveEvent(), let title = CountdownStringGenerator.titleForStatusItem(event: event) {
                content.text = title
            } else {
                content.image = StatusItemGlobals.currentIcon
            }
        }
        
        return content
        
    }
    
    func generateEventCountdownContent(for event: HLLEvent) -> HLLStatusItemContent {
        
        var content = HLLStatusItemContent()
        
        if event.completionStatus == .done {
            content.text = CountdownStringGenerator.titleForStatusItem(event: event)
            content.alpha = StatusItemGlobals.inactiveAlpha
            return content
        }
        
        content.text = CountdownStringGenerator.generateStatusItemString(event: event, mode: HLLDefaults.statusItem.mode)
        
      
        
        return content
        
    }
 
    
}
