//
//  IntentHandler.swift
//  How Long Left Widget Intents
//
//  Created by Ryan Kontos on 17/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Intents


class IntentHandler: INExtension, HLLWidgetConfigurationIntentHandling {

 

    override init() {
        
        super.init()
        
        HLLEventSource.shared.updateEvents()
        
    }
    
    
    
    override func handler(for intent: INIntent) -> Any {
        return self
    }
    
}
