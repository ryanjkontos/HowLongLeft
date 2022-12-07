//
//  PrimaryEventRowController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 22/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import WatchKit

class PrimaryEventRowController: NSObject, EventRow {
    
    @IBOutlet weak var titleLabel: WKInterfaceLabel?
    @IBOutlet weak var countdownLabel: WKInterfaceLabel?
    @IBOutlet weak var countdownTypeLabel: WKInterfaceLabel?
    @IBOutlet weak var infoLabel: WKInterfaceLabel?
    
    var event: HLLEvent!
    var rowCompletionStatus: HLLEvent.CompletionStatus!
    let percentageCalculator = PercentageCalculator()
    
    func setup(event: HLLEvent) {
        
        self.event = event
        self.rowCompletionStatus = event.completionStatus
        
    }
    
    func updateRow() {
        
        var infoLabelText: String?
               
            if event.completionStatus == .Upcoming {
                   
                infoLabelText = "(\(event.compactInfoText))"
                   
            } else {
                   
                let percent = percentageCalculator.calculatePercentageDone(for: event)
                    
                    infoLabelText = "(\(percent) Done)"
                    
                    if let location = event.location {
                        
                        let shortLocation = location.truncated(limit: 15, position: .tail, leader: "...")
                        
                        infoLabelText = "\(shortLocation) | \(percent)"
                        
                    }

                }
        
        if let infoLabelTextSafe = infoLabelText {
            
            self.infoLabel?.setText(infoLabelTextSafe)
            self.infoLabel?.setHidden(false)
            
        } else {
            
            self.infoLabel?.setHidden(true)
        }
        
        if let colour = self.event.associatedCalendar?.cgColor {
            self.countdownLabel?.setTextColor(UIColor(cgColor: colour))
        }
        
        self.titleLabel?.setText(self.event.title)
        self.countdownTypeLabel?.setText("\(self.event.countdownTypeString)")
        
        if let label = self.countdownLabel {
            
                var size = 38
                
                switch WKInterfaceDevice.currentResolution() {
                case .Watch38mm:
                    size = 36
                case .Watch44mm:
                    size = 40
                case .Watch40mm:
                    break
                case .Watch42mm:
                    break
                case .Unknown:
                    break
                }
                
            let string = self.countdownStringGenerator.generatePositionalCountdown(event: self.event)
            let monospacedFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size), weight: UIFont.Weight.semibold)
                let monospacedString = NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: monospacedFont])
                label.setAttributedText(monospacedString)
            
        }
            
        

    }
    
}
