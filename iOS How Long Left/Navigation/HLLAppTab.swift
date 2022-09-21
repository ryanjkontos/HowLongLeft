//
//  HLLAppTab.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 17/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation

enum HLLAppTab: Int, CaseIterable, Identifiable, Hashable {
    
    case inProgress
    case upcoming
    case settings
    
    var id: Int { rawValue }
    
    
    
    func tabName() -> String {
        
        switch self {
        case .inProgress:
            return "Countdowns"
        case .upcoming:
            return "Upcoming"
        case .settings:
            return "Settings"
        }
        
    }
    
    func imageName() -> String {
        
        switch self {
        case .inProgress:
            return "hourglass"
        case .upcoming:
            return "calendar.day.timeline.trailing"
        case .settings:
            return "gearshape.fill"
        }
        
    }
    
}
