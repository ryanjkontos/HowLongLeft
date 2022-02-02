//
//  PreviousEventRowController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 13/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import WatchKit

class PreviousEventRowController: NSObject, EventRow {
    
    @IBOutlet weak var eventTitleLabel: WKInterfaceLabel!
    
    var event: HLLEvent!
    var rowCompletionStatus: HLLEvent.CompletionStatus!
    
    func setup(event: HLLEvent) {
        
        self.event = event
        self.rowCompletionStatus = event.completionStatus
     
        
        
    }
    
    func updateRow() {
        
        DispatchQueue.main.async {
        
            self.eventTitleLabel.setText(self.event.title)
            self.eventTitleLabel.setTextColor(self.event.uiColor)
            
        }
    }
    
}
