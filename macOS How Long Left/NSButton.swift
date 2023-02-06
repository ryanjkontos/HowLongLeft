//
//  NSButton.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 17/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

extension NSButton {
    
    var isOn: Bool {
        
        get {
        
        if self.state == .on {
           return true
        } else {
            return false
        }
            
        }
        
        set (to) {
            
            var value = NSControl.StateValue.off
            if to {
                value = .on
            }
            
            self.state = value
            
            
        }
        
    }
    
}
