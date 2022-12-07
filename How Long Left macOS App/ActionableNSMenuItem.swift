//
//  ActionableNSMenuItem.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 23/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

class HLLMenuItem: NSMenuItem {
    
    convenience init(title: String, closure: (() -> Void)? = nil) {
        self.init()
        self.title = title
        self.closure = closure
    }
    
    var submenuClosure: (() -> NSMenu)? {
        
        didSet {
            
            self.submenu = NSMenu()
            
        }
        
    }
    
    var closure: (() -> Void)? {
        
        didSet {
            
            self.target = self
            self.action = #selector(runAction)
            
        }
        
    }
    
    @objc private func runAction() {
        
        closure?()
        
    }
    
    func generateSubmenu() {
        
        
        if let generatedMenu = submenuClosure?() {
            
            // print("Setting genned menu")
            
            self.submenu = generatedMenu
            
        }
        
    }
    
    
}
