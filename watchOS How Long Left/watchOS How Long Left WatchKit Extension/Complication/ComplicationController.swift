//
//  ComplicationController.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 22/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import ClockKit
import WidgetKit
import os.log



class ComplicationController: NSObject, CLKComplicationDataSource {
    
    static let logger = Logger(subsystem: "ComplicationController", category: "Info")
    
    static let timelineGen = HLLTimelineGenerator(type: .complication)
    
    static var timeline: HLLTimeline = ComplicationController.timelineGen.generateHLLTimeline(fast: false, percentages: false, forState: .normal)
    
    static var updates = 0
    
    let entryGenerator = ComplicationEntryGenerator()
    
    // MARK: - Complication Configuration

    
    let enabledDescriptors = [
        
        // Graphic Circular
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCircular.progressRing.rawValue, displayName: "Event Progress Ring", supportedFamilies: [CLKComplicationFamily.graphicCircular]),
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCircular.titleAndCountdown.rawValue, displayName: "Event Title + Countdown", supportedFamilies: [CLKComplicationFamily.graphicCircular]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCircular.icon.rawValue, displayName: "Icon", supportedFamilies: [CLKComplicationFamily.graphicCircular]),
        
        // Graphic Rectangular
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicRectangular.eventPlusInfo.rawValue, displayName: "Countdown + Info", supportedFamilies: [CLKComplicationFamily.graphicRectangular]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicRectangular.largeCountdown.rawValue, displayName: "Large Countdown", supportedFamilies: [CLKComplicationFamily.graphicRectangular]),
        
        // Graphic Corner
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCorner.progressRing.rawValue, displayName: "Event Progress Bar", supportedFamilies: [CLKComplicationFamily.graphicCorner]),
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCorner.titleAndCountdown.rawValue, displayName: "Event Title + Countdown", supportedFamilies: [CLKComplicationFamily.graphicCorner]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCorner.icon.rawValue, displayName: "Icon", supportedFamilies: [CLKComplicationFamily.graphicCorner]),
        
        
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicExtraLarge.progressRing.rawValue, displayName: "Event Progress Ring", supportedFamilies: [CLKComplicationFamily.graphicExtraLarge]),
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicExtraLarge.titleAndCountdown.rawValue, displayName: "Event Title + Countdown", supportedFamilies: [CLKComplicationFamily.graphicExtraLarge]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicExtraLarge.icon.rawValue, displayName: "Icon", supportedFamilies: [CLKComplicationFamily.graphicExtraLarge]),
        
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicBezel.countdownAndProgressRing.rawValue, displayName: "Countdown + Progress Ring", supportedFamilies: [CLKComplicationFamily.graphicBezel]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicBezel.icon.rawValue, displayName: "Icon", supportedFamilies: [CLKComplicationFamily.graphicBezel]),
        
        
       
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.UtilitarianLarge.titleAndCountdown.rawValue, displayName: "Event Title + Countdown", supportedFamilies: [CLKComplicationFamily.utilitarianLarge]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.UtilitarianSmall.titleAndCountdown.rawValue, displayName: "Countdown", supportedFamilies: [CLKComplicationFamily.utilitarianSmall]),
        
        
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.UtilitarianSmall.titleAndCountdown.rawValue, displayName: "Countdown", supportedFamilies: [CLKComplicationFamily.circularSmall]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.UtilitarianSmallFlat.countdown.rawValue, displayName: "Countdown", supportedFamilies: [CLKComplicationFamily.utilitarianSmallFlat]),
        
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.ModularLarge.countdown.rawValue, displayName: "Countdown + Info", supportedFamilies: [CLKComplicationFamily.modularLarge]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.ModularLarge.largeCountdown.rawValue, displayName: "Large Countdown", supportedFamilies: [CLKComplicationFamily.modularLarge]),
        
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.ModularSmall.countdown.rawValue, displayName: "Countdown", supportedFamilies: [CLKComplicationFamily.modularSmall]),
        
        
    ]

    
    static func updateComplications(forced: Bool) {
        
        
         timeline = ComplicationController.timelineGen.generateHLLTimeline(fast: false, percentages: false, forState: .normal)
        
        var state: HLLTimelineGenerator.TimelineValidity
        if forced {
            state = .needsReloading
        } else {
            state = ComplicationController.timelineGen.shouldUpdate()
        }
        
        
        if state != .noUpdateNeeded {
            ComplicationController.timeline = timeline
           
                
            ComplicationController.updates += 1
            // print("Updating complication now: \(ComplicationController.updates)")
            
         //   let activeComplications = CLKComplicationServer.sharedInstance().activeComplications?.first!.
            
            ComplicationLogger.log("Reloading Complication")
            CLKComplicationServer.sharedInstance().activeComplications?.forEach({ CLKComplicationServer.sharedInstance().reloadTimeline(for: $0) })
          
        } else {
            print("No complication update needed")
        }
      
    }
    
    static func updateDescriptors() {
        
        CLKComplicationServer.sharedInstance().reloadComplicationDescriptors()
        
        Task {
            ComplicationController.updateComplications(forced: false)
        }
        
    }
    
    override init() {
        super.init()
        ComplicationController.logger.log("Init complicationcontroller")
        
        
        
    }
    
    func timelineEntries(complication: CLKComplication, date: Date?, limit: Int? = nil) -> [CLKComplicationTimelineEntry] {
        
        
        
        var overrideTemplate: CLKComplicationTemplate?
        
        if CalendarReader.shared.calendarAccess == .Denied {
            overrideTemplate = entryGenerator.generateNoCalendarAccessComplicationTemplate(complication: complication)
        }
        
        if HLLDefaults.watch.complicationEnabled == false {
            overrideTemplate = entryGenerator.generateNotEnabledComplicationTemplate(complication: complication)
        }
       
        if let template = overrideTemplate {
            return [(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template))]
        }
        
        
        var timelineEntries = ComplicationController.timeline.entriesAfterDate(date)
        HLLDefaults.complication.latestTimeline = ComplicationController.timeline.getArchive()
        if let limit = limit {
            timelineEntries = Array(timelineEntries.prefix(limit))
        }
        let complicationEntires = timelineEntries.compactMap({
            entryGenerator.getTimelineEntryComplicationEntry(complication: complication,timelineEntry: $0)
        })
        
        
       
        ComplicationController.logger.log("Returned \(complicationEntires.count) complication entires")
        ComplicationController.logger.log("Timeline generated: \(ComplicationController.timeline.creationDate.timeIntervalSinceNow)")
        
        return complicationEntires
        
        
        
    }
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        
        handler(enabledDescriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        
        if HLLDefaults.watch.complicationEnabled {
            handler(ComplicationController.timeline.entries.last!.getAdjustedDate())
        } else {
            handler(Date().addDays(365))
        }
        
        
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        
        print("Get current timeline entry")
        ComplicationController.logger.log("Asked for current entry")
    
        
        handler(timelineEntries(complication: complication, date: Date()).first)
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    
        // print("First entry is at: \(ComplicationController.timeline.entries.first!.getAdjustedDate().formattedTime(seconds: true)), reuqested: \(date.formattedTime(seconds: true))")
        
        print("\(Date()): Get current timeline entries after \(date)")
        
        ComplicationController.logger.log("Asked for all entries")
        
        handler(timelineEntries(complication: complication, date: date, limit: limit))
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
        let data = ComplicationProviderData(eventTitleText: "Event", firstRowText: "Event ends in", timerText: "1:05", countdownTimeText: "12:00pm", gaugeFillFraction: 0.25, countdownPrefixText: nil, tint: .orange, oneLineText: "Event: 1:05")
        
        let template = entryGenerator.generateComplicationTemplate(complication: complication, data: data)
        
        handler(template)
    }
}

