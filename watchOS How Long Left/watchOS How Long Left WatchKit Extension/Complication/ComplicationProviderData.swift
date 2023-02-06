//
//  ComplicationProviderData.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 25/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import ClockKit

struct ComplicationProviderData {
    
    var underlyingTimelineEntry: HLLTimelineEntry?
    
    let eventTitleProvider: CLKSimpleTextProvider
    var firstRowProvider: CLKSimpleTextProvider
    let timerProvider: CLKTextProvider
    let fullTimerProvider: CLKTextProvider
    let infoTextProvider: CLKTextProvider
    
    var gaugeProvider: CLKGaugeProvider?
    
    
    var titleAndCountdownProvider: CLKTextProvider?
    
    
    var fullColorTint: UIColor?
    
    var hideProgressBar = false
    
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
            
            let isInStartPeriod = data.date.timeIntervalSince(event.startDate) < (5*60)
            
            let tint = HLLDefaults.complication.tintComplication ? event.color : .orange
            
            if HLLDefaults.complication.tintComplication {
                fullColorTint = tint
            }
            
            let countdownDate = event.countdownDate(at: data.getAdjustedDate())
        
            
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
            
            firstRowProvider = CLKSimpleTextProvider(text: "\(event.title)")
            
            
            switch event.completionStatus(at: data.getAdjustedDate()) {
                case .upcoming:
                    
                    fullTimerProvider = CLKTextProvider(byJoining: ["in".simpleTextProvider(), timerProvider], separator: " ")
                case .current:
                    firstRowProvider = "\(event.title)".simpleTextProvider()
                fullTimerProvider = CLKTextProvider(byJoining: [timerProvider, " left".simpleTextProvider()], separator: nil)
                let tintArray = HLLDefaults.complication.tintComplication ? [event.color] : [UIColor(named: "HLLGradient1")!, UIColor(named: "HLLGradient2")!]
                
                gaugeProvider = CLKTimeIntervalGaugeProvider(style: .fill, gaugeColors: tintArray, gaugeColorLocations: nil, start: event.startDate, end: event.endDate)
                case .done:
                fullTimerProvider = timerProvider
                    break
            }
            
            eventTitleProvider = CLKSimpleTextProvider(text: "\(event.title)")
            eventTitleProvider.tintColor = tint
            firstRowProvider.tintColor = tint
           
            let locationTextProvider = (event.location ?? "No location").simpleTextProvider()
            let countdownDateProvider = CLKTimeTextProvider(date: countdownDate)
            
            let nextTextProvider: CLKTextProvider
            if let next = data.nextEvent {
                nextTextProvider = CLKTextProvider(byJoining: ["Next: ".simpleTextProvider(), next.title.simpleTextProvider()], separator: nil)
            } else {
                nextTextProvider = "Nothing Next".simpleTextProvider()
            }
            
            if isInStartPeriod, let altMode = HLLDefaults.complication.alternateThirdRowMode {
                
                hideProgressBar = true
                
                switch altMode {
                case .nextEvent:
                    infoTextProvider = nextTextProvider
                case .location:
                    infoTextProvider = locationTextProvider
                case .time:
                    infoTextProvider = countdownDateProvider
                }
                
            } else {
                switch HLLDefaults.complication.mainThirdRowMode {
                    
                case .nextEvent:
                    infoTextProvider = nextTextProvider
                case .location:
                    infoTextProvider = locationTextProvider
                case .time:
                    infoTextProvider = countdownDateProvider
                }
            }

     
            var array: [CLKTextProvider] = [eventTitleProvider, ": ".simpleTextProvider()]
            array.append(fullTimerProvider)
            titleAndCountdownProvider = CLKTextProvider(byJoining: array, separator: nil)
            
        } else {
            return nil
        }
            
    }
    
}
