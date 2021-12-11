//
//  CNTextCell.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 10/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class CNTextCell: NSTableCellView {
    
    var delegate: CNTableProtocol!
    @IBOutlet weak var label: NSTextField!
    
    
    
}
