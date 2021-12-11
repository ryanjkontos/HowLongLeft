//
//  StateValue.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 17/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

extension NSControl.StateValue {
    
    static func from(bool: Bool) -> NSControl.StateValue {
        if bool {
            return .on
        } else {
            return .off
        }
    }
    
    var isOn: Bool {
        
        if self == .on {
           return true
        } else {
            return false
        }
        
    }
    
}
