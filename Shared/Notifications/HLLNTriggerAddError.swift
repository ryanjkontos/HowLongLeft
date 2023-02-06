//
//  HLLNTriggerAddError.swift
//  How Long Left
//
//  Created by Ryan Kontos on 10/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLNTriggerAddError: Error {
    
    let errorTitle: String
    let errorReason: String
    
    internal init(errorTitle: String, errorReason: String) {
        self.errorTitle = errorTitle
        self.errorReason = errorReason
    }
    
}
