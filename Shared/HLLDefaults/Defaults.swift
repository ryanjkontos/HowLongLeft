//
//  Defaults.swift
//  How Long Left
//
//  Created by Ryan Kontos on 2/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import Defaults

extension Defaults.Keys {
    
    static let launchedVersion = Key<String?>("launchedVersion", default: nil, suite: HLLDefaults.defaults)
    static let newestLaunchedVersion = Key<String?>("hideCurrentInCountdownsTab", default: nil, suite: HLLDefaults.defaults)
    
    static let proUser = Key<String?>("hideCurrentInCountdownsTab", default: nil, suite: HLLDefaults.defaults)
    
    
    
    
}

