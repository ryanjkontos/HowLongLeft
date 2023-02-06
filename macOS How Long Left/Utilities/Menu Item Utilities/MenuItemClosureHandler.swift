//
//  MenuItemClosureHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 23/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class MenuItemClosureHandler {
    
    static var shared = MenuItemClosureHandler()
    
    @objc func runClosureFor(sender: NSMenuItem) {
        
        if let closure = sender.representedObject as? () -> Void {
            
            DispatchQueue.main.async {
                
                closure()
                
            }
            
        }
        
    }


    
    
}
