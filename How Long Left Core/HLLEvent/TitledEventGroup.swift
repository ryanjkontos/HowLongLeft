//
//  TitledEventGroup.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

struct TitledEventGroup: Equatable, Identifiable, Hashable {
    
    var id: String {
        
        return (title ?? "") + events.map({$0.infoIdentifier}).joined()
        
    }
    
    var isEmpty: Bool {
        
        get {
            
            return events.isEmpty
            
        }
        
    }
    
    var title: String?
    var events: [HLLEvent]
    
    
}
