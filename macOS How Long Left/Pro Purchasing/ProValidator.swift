//
//  ProValidator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class ProValidator {
    
    static var shared = ProValidator()
    
    func getProPurchaseID() -> String {
        
       
        let serial = Mac.current.serialNumber
        return "HLLProPurchaseID: \(serial)".hashed
        
    }
    
}
