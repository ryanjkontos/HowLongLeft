//
//  UIColor.swift
//  How Long Left
//
//  Created by Ryan Kontos on 6/4/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static var HLLOrange: UIColor {
        
        get {
            
            let col = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            return col
            
            
        }
        
        
    }
    
    func HLLCalendarGradient() -> [UIColor] {
        
        return [self.lighter(by: 13)!, self.darker(by: 10)!]
        
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
