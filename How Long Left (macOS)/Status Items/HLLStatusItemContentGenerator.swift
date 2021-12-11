//
//  StatusItemUpdateHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 7/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class HLLStatusItemContentGenerator {
   
    
    let countdownStringGenerator = CountdownStringGenerator()

    func getStatusItemContent(for configuration: HLLStatusItemConfiguration) -> HLLStatusItemContent {
        
        var returnContent: HLLStatusItemContent
    
        if HLLEventSource.accessToCalendar == .Denied {
            var content = HLLStatusItemContent()
            content.text = "⚠️"
            return content
        }
        
        if let event = configuration.eventRetriver.retrieveEvent() {
            returnContent = generateEventCountdownContent(for: event)
        } else {
            returnContent = generateNoEventContent(config: configuration)
        }
        
        if HLLDefaults.statusItem.mode == .Off  {
            returnContent = generateNoEventContent(config: configuration, inactive: true)
        }
        
       /* if HLLEventSource.shared.updating {
            returnContent.alpha = StatusItemGlobals.inactiveAlpha
        }*/
        
        return returnContent
        
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
            if let title = config.eventRetriver.retrieveEvent()?.titleForStatusItem {
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
            content.text = event.titleForStatusItem
            content.alpha = StatusItemGlobals.inactiveAlpha
            return content
        }
        
        content.text = self.countdownStringGenerator.generateStatusItemString(event: event, mode: HLLDefaults.statusItem.mode)
        
      
        
        return content
        
    }
 
    
}
