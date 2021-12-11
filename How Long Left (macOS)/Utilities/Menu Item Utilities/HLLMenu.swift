//
//  HLLMenu.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 9/9/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

class HLLMenu: NSMenu, NSMenuDelegate {

    convenience init() {
        self.init(title: "")
        self.delegate = self
    }
    
   override init(title: String) {
       super.init(title: title)
    self.delegate = self
   }

   required init(coder decoder: NSCoder) {
       super.init(coder: decoder)
    self.delegate = self
   }
    
    
    
    func menuWillOpen(_ menu: NSMenu) {
        
        
        
        for item in self.items {
            
            if let hllItem = item as? HLLMenuItem {
                
                hllItem.generateSubmenu()
                
            }
            
        }
        
    }
    
}
