//
//  HLLStatusItemConfiguration.swift
//  How Long Left (macOS)
//
//  Created by Ryan on 29/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

struct HLLStatusItemConfiguration {
    
    var type: HLLStatusItemType
    var eventRetriver: HLLEventRetriever
    var selfDestructs = false
    
    internal init(type: HLLStatusItemType, eventRetriver: HLLEventRetriever) {
        self.type = type
        self.eventRetriver = eventRetriver
    }
    
    static func defaultConfiguration() -> HLLStatusItemConfiguration {
        
        return HLLStatusItemConfiguration(type: .main, eventRetriver: HLLEventRetrieverMain())
        
    }
    
    static func eventConfiguration(_ event: HLLEvent) -> HLLStatusItemConfiguration {
        
        return HLLStatusItemConfiguration(type: .event, eventRetriver: HLLEventRetrieverPersistent(event))
        
    }
    
}
