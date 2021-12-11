//
//  AppMenuHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

class AppMenuHandler: NSObject {
    
    @IBAction func aboutClicked(_ sender: NSMenuItem) {
        
        AboutWindowManager.shared.showProOnboarding()
        
        
    }
    
    

}
