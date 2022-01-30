//
//  EventCompletionStatus.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

enum EventCompletionStatus: CustomDebugStringConvertible {
    case upcoming
    case current
    case done
    
    var debugDescription: String {
        
        switch self {
        case .upcoming:
            return "Upcoming"
        case .current:
            return "Current"
        case .done:
            return "Done"
        }
        
    }
    
}
