//
//  LiveEventAttributes.swift
//  How Long Left
//
//  Created by Ryan Kontos on 19/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation
#if !targetEnvironment(macCatalyst)
import ActivityKit

struct LiveEventAttributes: ActivityAttributes {
    public typealias LiveEventStatus = ContentState

    public struct ContentState: Codable, Hashable {
        
        
    }

    var event: HLLEvent
   
}

#endif
