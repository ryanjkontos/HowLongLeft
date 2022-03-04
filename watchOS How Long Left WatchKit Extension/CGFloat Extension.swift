//
//  CGFloat Extension.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 26/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import WatchKit

extension CGFloat {
    
    static func watchDynamic(size38mm: CGFloat, size40mm: CGFloat, size41mm: CGFloat, size42mm: CGFloat, size44mm: CGFloat, size45mm: CGFloat) -> CGFloat {
    
        
        switch WKInterfaceDevice.current().device {
            
        case .unknown:
            return size41mm
        case .watch38mm:
            return size38mm
        case .watch40mm:
            return size40mm
        case .watch41mm:
            return size41mm
        case .watch42mm:
            return size42mm
        case .watch44mm:
            return size44mm
        case .watch45mm:
            return size45mm
        }
        
        
        
    }
    
    
}
