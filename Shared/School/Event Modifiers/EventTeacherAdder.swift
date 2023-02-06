//
//  EventTeacherAdder.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class EventTeacherAdder {
    
    static var shared = EventTeacherAdder()
    
    func replaceTeacherString(of: String) -> String {
        
        var returnString = of
        
        if let dict = HLLDefaults.defaults.object(forKey: "TeachersDictionary") as? [String:String] {
                
            for item in dict {
                
                if of.lowercased().contains(text: item.key.lowercased()) {
                    
                    
                    
                    if item.value != "*" {
                        returnString = item.value
                    }
                    
                }
                
            }
                
        }
        
        return returnString
        
    }
    
    
}
