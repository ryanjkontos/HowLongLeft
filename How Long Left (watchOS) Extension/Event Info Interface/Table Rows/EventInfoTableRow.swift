//
//  EventInfoTableRow.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 28/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import WatchKit

class EventInfoTableRow: NSObject {
    
    var infoItem: HLLEventInfoItem!
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var infoLabel: WKInterfaceLabel!
    
    func setup(with infoItem: HLLEventInfoItem) {
        
        self.infoItem = infoItem
        
        titleLabel.setText(infoItem.title)
        infoLabel.setText(infoItem.info)
        
    }
    
}
