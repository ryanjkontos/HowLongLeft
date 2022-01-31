//
//  ComplicationProviderData.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 25/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

struct ComplicationProviderData {
    
    var underlyingTimelineEntry: HLLTimelineEntry?
    
    let eventTitleProvider: CLKSimpleTextProvider
    let firstRowProvider: CLKSimpleTextProvider
    let timerProvider: CLKTextProvider
    let fullTimerProvider: CLKTextProvider
    let infoTextProvider: CLKTextProvider
    
    var gaugeProvider: CLKGaugeProvider?
    
    
    var titleAndCountdownProvider: CLKTextProvider?
    
    
    var fullColorTint: UIColor?
    
    internal init(eventTitleText: String, firstRowText: String, timerText: String, countdownTimeText: String, gaugeFillFraction: Float?, countdownPrefixText: String?, tint: UIColor, oneLineText: String) {
        
        self.eventTitleProvider = CLKSimpleTextProvider(text: eventTitleText)
        self.eventTitleProvider.tintColor = tint
        
        self.firstRowProvider = CLKSimpleTextProvider(text: firstRowText)
        self.firstRowProvider.tintColor = tint
        
        self.timerProvider = CLKSimpleTextProvider(text: timerText)
        
        self.fullTimerProvider = timerProvider
    
        self.infoTextProvider = CLKSimpleTextProvider(text: countdownTimeText)
        
        self.titleAndCountdownProvider = oneLineText.simpleTextProvider()
        
        if let gaugeFillFraction = gaugeFillFraction {
            self.gaugeProvider = CLKSimpleGaugeProvider(style: .fill, gaugeColor: tint, fillFraction: gaugeFillFraction)
        }
    
       
    }
    
    init?(_ data: HLLTimelineEntry) {
        
        underlyingTimelineEntry = data
        
        if let event = data.event {
            
            let tint = HLLDefaults.complication.tintComplication ? event.color : .orange
            
            if HLLDefaults.complication.tintComplication {
                fullColorTint = tint
            }
            
            let countdownDate = event.countdownDate(at: data.showAt)
        
            
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
            
            switch event.completionStatus(at: data.showAt) {
                case .upcoming:
                    fullTimerProvider = CLKTextProvider(byJoining: ["in".simpleTextProvider(), timerProvider], separator: " ")
                case .current:
                    fullTimerProvider = CLKTextProvider(byJoining: [timerProvider], separator: " ")
                let tintArray = HLLDefaults.complication.tintComplication ? [event.color] : [UIColor(named: "HLLGradient1")!, UIColor(named: "HLLGradient2")!]
                
                gaugeProvider = CLKTimeIntervalGaugeProvider(style: .fill, gaugeColors: tintArray, gaugeColorLocations: nil, start: event.startDate, end: event.endDate)
                case .done:
                fullTimerProvider = timerProvider
                    break
            }
            
            eventTitleProvider = CLKSimpleTextProvider(text: "\(event.title)")
            eventTitleProvider.tintColor = tint
            firstRowProvider = CLKSimpleTextProvider(text: "\(event.title)")
            firstRowProvider.tintColor = tint
            

         
            
        
            if let location = event.location {
                infoTextProvider = location.simpleTextProvider()
            } else {
                infoTextProvider = CLKTimeTextProvider(date: countdownDate)
            }
            
            var array: [CLKTextProvider] = [eventTitleProvider, ": ".simpleTextProvider()]
            array.append(fullTimerProvider)
            titleAndCountdownProvider = CLKTextProvider(byJoining: array, separator: nil)
            
        } else {
            return nil
        }
            
    }
    
}
