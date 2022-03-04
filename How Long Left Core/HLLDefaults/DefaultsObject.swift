//
//  DefaultsObject.swift
//  How Long Left
//
//  Created by Ryan Kontos on 19/2/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class DefaultsObject<ObjectType> {
    
    private let key: String
    
    private let defaultValue: ObjectType
    
    init(_ key: String, defaultValue: ObjectType) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var value: ObjectType {
        
        if let object = HLLDefaults.defaults.object(forKey: key) as? ObjectType {
            return object
        } else {
            return defaultValue
        }
        
    }
    
}
