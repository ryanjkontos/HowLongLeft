//
//  CurrentEventRowController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 22/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import WatchKit

class CurrentEventRowController: NSObject, EventRow {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel!
    @IBOutlet weak var countdownLabel: WKInterfaceLabel!
    
    var event: HLLEvent!
    var rowCompletionStatus: HLLEvent.CompletionStatus!
    let countdownStringGenerator = CountdownStringGenerator()
    
    func setup(event: HLLEvent) {
        
        self.event = event
        self.rowCompletionStatus = event.completionStatus
        
    }
    
    func updateRow() {
       
        self.titleLabel?.setText("\(self.event.title) \(self.event.countdownTypeString)")
        self.titleLabel?.setTextColor(.white)
            
        if let colour = self.event.associatedCalendar?.cgColor {
        self.countdownLabel?.setTextColor(UIColor(cgColor: colour))
            
        }
        
        if let label = self.countdownLabel {
                    
            let string = self.countdownStringGenerator.generatePositionalCountdown(event: self.event)
        
            let monospacedFont = UIFont.monospacedDigitSystemFont(ofSize: 27, weight: UIFont.Weight.semibold)
            let monospacedString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: monospacedFont])
            label.setAttributedText(monospacedString)
                    
        }
            
        
        
    }
    
}
