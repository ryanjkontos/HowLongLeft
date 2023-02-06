//
//  IntentHandler.swift
//  iOS Widget Intents
//
//  Created by Ryan Kontos on 6/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        return self
    }
    
}
