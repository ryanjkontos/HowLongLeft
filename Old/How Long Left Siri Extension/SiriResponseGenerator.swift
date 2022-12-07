//
//  SiriResponseGenerator.swift
//  How Long Left Siri Extension
//
//  Created by Ryan Kontos on 28/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class SiriResponseGenerator {
    

    func generateResponseForCurrentEvent() -> String {
        
        if let event = HLLEventSource.shared.getPrimaryEvent() {
            
            let remaining = CountdownStringGenerator.generateCountdownTextFor(event: event)
            
            return "\(event.title) \(event.countdownTypeString) \(remaining)."
            
            
        } else {

            return "No events are on right now."
            
            
        }
        
        
    }
    
    
    
    
    
}
