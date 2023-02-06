//
//  Subject.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

enum Subject: String, CaseIterable {
    
    case englishStandard = "English Standard"
    case englishAdvanced = "English Advanced"
    case englishStudies = "English Studies"
    case music = "Music"
    
    static var asArray: [Subject] {return self.allCases}

    var intValue: Int {
        
        get {
            return Subject.asArray.firstIndex(of: self)!
        }
    }
    
}
