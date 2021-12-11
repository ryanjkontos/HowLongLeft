//
//  ProInfoStringGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class ProInfoStringGenerator {
    
    static var shared = ProInfoStringGenerator()
    
    func generateProInfoString(isForOnboarding: Bool) -> String {
        
        var string = "How Long Left Pro is a one time purchase "
        
        if let price = ProPurchaseHandler.shared.proPrice {
            
            string += "of \(price) "
            
        }
        
        string += "that enables several new features, including the ability to hide events, create custom notification triggers, drag events into the app from your calendar, set nicknames for your events, "
        
        if #available(OSX 11, *) {
            
            string += "widgets, "
            
        }
        
        string += "and more."
        
        
        return string
        
    }
    
    
    
    
}
