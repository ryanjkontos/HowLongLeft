//
//  EventMenuInfoView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 13/10/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Cocoa

class EventMenuInfoView: NSView, NibLoadable {

    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet weak var bar: NSProgressIndicator!
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        self.window?.makeKeyAndOrderFront(self)
        
        
        bar.controlTint = .defaultControlTint
    }
    
    func update(for event: HLLEvent) {
        self.titleLabel.stringValue = event.title
    }
    
    
    
}

