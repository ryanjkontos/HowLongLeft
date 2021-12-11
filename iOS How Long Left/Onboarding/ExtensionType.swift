//
//  ExtensionType.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 22/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation

enum ExtensionType: String, CaseIterable, Identifiable {
    
    case widget = "HLLWidget"
    case complication = "ComplicationIAPHLL"
    
    
    var id: String { return self.rawValue }
    
    func getName() -> String {
        
        switch self {
        case .complication:
            return "Watch Complication"
        case .widget:
            return "Home Screen Widget"
        }
        
    }
    
    func imageName() -> String {
        
        switch self {
        case .complication:
            return "applewatch.watchface"
        case .widget:
            return "rectangle.3.group"
        }
    }
    
}
