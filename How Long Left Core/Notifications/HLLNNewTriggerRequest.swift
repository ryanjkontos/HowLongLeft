//
//  HLLNNewTriggerRequest.swift
//  How Long Left
//
//  Created by Ryan Kontos on 10/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLNNewTriggerRequest {
    
    let type: HLLNTriggerType
    let value: Int
    var previousValue: Int?
    
    internal init(type: HLLNTriggerType, value: Int, previousValue: Int? = nil) {
        self.type = type
        self.value = value
        self.previousValue = previousValue
    }
    
}
