//
//  CountdownText.swift
//  How Long Left
//
//  Created by Ryan Kontos on 26/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class CountdownText {
    
    var mainText: String
    var percentageText: String?
    var justCountdown: String
    
    internal init(mainText: String, percentageText: String? = nil, justCountdown: String) {
        self.mainText = mainText
        self.percentageText = percentageText
        self.justCountdown = justCountdown
    }
    
    func combined() -> String {
        
        if let percentageText = self.percentageText {
            
            return "\(mainText) (\(percentageText))"
            
        } else {
            
            return mainText
            
        }
    }
}
