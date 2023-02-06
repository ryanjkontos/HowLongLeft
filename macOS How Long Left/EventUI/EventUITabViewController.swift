//
//  EventUITabViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

class EventUITabViewController: ControllableTabView {

    var event: HLLEvent?
    
    override func viewDidAppear() {
        
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.isMovableByWindowBackground = true
        
        
    }

    
}

class NoLoseFoucus: NSWindow {
    
    
}
