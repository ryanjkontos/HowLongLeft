//
//  Pluraliser.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class Pluraliser {
    
    internal init(singular: String, plural: String) {
        self.singular = singular
        self.plural = plural
    }
    
    var singular: String
    var plural: String
    
    func pluralise(from count: Int) -> String {
        
        if count == 1 {
            return singular
        } else {
            return plural
        }
        
    }
    
}
