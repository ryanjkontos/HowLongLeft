//
//  HLLNTriggerType.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 8/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

enum HLLNTriggerType: Equatable {
    
    case timeInterval(CNTimeIntervalTriggerType)
    case percentageComplete
    
    
    
}

enum CNTimeIntervalTriggerType: Equatable {
    case timeUntil
    case timeRemaining
}
