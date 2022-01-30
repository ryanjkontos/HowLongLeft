//
//  ComplicationProviderData.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 25/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

struct ComplicationProviderData {
    
    
    let eventTitleProvider: CLKSimpleTextProvider
    let firstRowProvider: CLKSimpleTextProvider
    let timerProvider: CLKTextProvider
    let countdownTimeProvider: CLKTextProvider
    
    var gaugeProvider: CLKGaugeProvider?
    var countdownPrefixTextProvider: CLKSimpleTextProvider?
    
    var titleAndCountdownProvider: CLKTextProvider?
    
    var fullColorTint: UIColor?
    
    internal init(eventTitleText: String, firstRowText: String, timerText: String, countdownTimeText: String, gaugeFillFraction: Float?, countdownPrefixText: String?, tint: UIColor, oneLineText: String) {
        
        self.eventTitleProvider = CLKSimpleTextProvider(text: eventTitleText)
        self.eventTitleProvider.tintColor = tint
        
        self.firstRowProvider = CLKSimpleTextProvider(text: firstRowText)
        self.firstRowProvider.tintColor = tint
        
        self.timerProvider = CLKSimpleTextProvider(text: timerText)
        
        self.countdownTimeProvider = CLKSimpleTextProvider(text: countdownTimeText)
        
        self.titleAndCountdownProvider = oneLineText.simpleTextProvider()
        
        if let gaugeFillFraction = gaugeFillFraction {
            self.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: tint, fillFraction: gaugeFillFraction)
        }
        if let countdownPrefixText = countdownPrefixText {
            self.countdownPrefixTextProvider = CLKSimpleTextProvider(text: countdownPrefixText)
        }
        
        
       
    }
    
    init?(_ data: HLLTimelineEntry) {
        
        
        
        if let event = data.event {
            
            let tint = HLLDefaults.complication.tintComplication ? event.color : .orange
            
            if HLLDefaults.complication.tintComplication {
                fullColorTint = tint
            }
            
            let countdownDate = event.countdownDate(at: data.showAt)
        
            switch event.completionStatus(at: data.showAt) {
                case .upcoming:
                    countdownPrefixTextProvider = CLKSimpleTextProvider(text: "in")
                case .current:
                
                let tintArray = HLLDefaults.complication.tintComplication ? [event.color] : [UIColor(named: "HLLGradient1")!, UIColor(named: "HLLGradient2")!]
                
                gaugeProvider = CLKTimeIntervalGaugeProvider(style: .fill, gaugeColors: tintArray, gaugeColorLocations: nil, start: event.startDate, end: event.endDate)
                case .done:
                    break
            }
            
            eventTitleProvider = CLKSimpleTextProvider(text: "\(event.title)")
            eventTitleProvider.tintColor = tint
            firstRowProvider = CLKSimpleTextProvider(text: "\(event.title) \(event.countdownTypeString(at: data.showAt)) in")
            firstRowProvider.tintColor = tint
            

            
            var units: NSCalendar.Unit
            var style: CLKRelativeDateStyle
            
            if HLLDefaults.complication.showSeconds {
                units = [.hour, .minute, .second, .day]
            } else {
                units = [.hour, .minute, .day]
            }
            
            if HLLDefaults.complication.unitLabels {
                style = .naturalAbbreviated
            } else {
                style = .timer
            }
            
            timerProvider = CLKRelativeDateTextProvider(date: countdownDate, style: style, units: units)
            countdownTimeProvider = CLKTimeTextProvider(date: countdownDate)
        
            var array: [CLKTextProvider] = [eventTitleProvider, ": ".simpleTextProvider()]
            if let prefixProvider = countdownPrefixTextProvider {
                array.append(prefixProvider)
                array.append(" ".simpleTextProvider())
            }
            array.append(timerProvider)
            titleAndCountdownProvider = CLKTextProvider(byJoining: array, separator: nil)
            
        } else {
            return nil
        }
            
    }
    
}
