//
//  CNCheckView.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 10/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class CNCheckView: NSTableCellView {
    
    @IBOutlet weak var checkBox: NSButton!
    
    var delegate: CNTableProtocol!
    
    @IBAction func checkClicked(_ sender: NSButton) {
        delegate.update()
        
    }
    
}
