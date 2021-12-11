//
//  StatusItemEventMode.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 18/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

enum StatusItemEventMode: Int {
    
    case bothPreferSoonest = 0
    case bothPreferCurrent = 1
    
    case currentOnly = 2
    case upcomingOnly = 3
    
    case onlySelected = 4
    
}
