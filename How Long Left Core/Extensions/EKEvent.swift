//
//  EKEvent.swift
//  How Long Left
//
//  Created by Ryan Kontos on 5/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

extension EKEvent {
    
    func asHLLEvent() -> HLLEvent {
        
        return HLLEvent(event: self)
        
    }
    
}
