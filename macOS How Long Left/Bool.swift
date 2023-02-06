//
//  Bool.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 17/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

extension Bool {
    
    var controlStateValue: NSControl.StateValue {
        
        get {
            
            if self {
                return .on
            } else {
                return .off
            }
            
        }
        
    }
    
    
}
