//
//  UIInterfaceTimer.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 22/1/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit

class UIInterfaceTimer: UILabel {
    
    var date: Date?
    lazy var updateTimer = RepeatingTimer(time: 0.1)
    
    init() {
        
        super.init
        
        font = UIFont.monospacedDigitSystemFont(ofSize: font.pointSize, weight: .regular)
        
        updateTimer.eventHandler = {
            
            self.update()
            
        }
        
        updateTimer.resume()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func update() {
        
        var returnString = "00:00"
        
        if let uDate = date {
        
        let secondsLeft = uDate.timeIntervalSince(Date()).rounded(.down)
        
        if secondsLeft > -2 {
            
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            
            if secondsLeft+1 > 86400 {
                
                formatter.allowedUnits = [.day]
                
            } else if secondsLeft+1 > 3599 {
                
                formatter.allowedUnits = [.hour, .minute, .second]
                
            } else {
                
                formatter.allowedUnits = [.minute, .second]
            }
            
            formatter.zeroFormattingBehavior = [ .pad ]
            let formattedDuration = formatter.string(from: secondsLeft+1)
            
            returnString = "\(formattedDuration!)"
            
            
        }
        
    }
        text = returnString
        
    }
    
}
