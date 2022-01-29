//
//  ComplicationController.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 22/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    static let timelineGen = HLLTimelineGenerator(type: .complication)
    
    static var timeline: HLLTimeline = ComplicationController.timelineGen.generateTimelineItems(fast: false, percentages: false, forState: .normal)
    
    static var updates = 0
    
    let entryGenerator = ComplicationEntryGenerator()
    
    // MARK: - Complication Configuration

    let enabledDescriptors = [
        
        // Graphic Circular
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCircular.progressRing.rawValue, displayName: "Event Progress Ring", supportedFamilies: [CLKComplicationFamily.graphicCircular]),
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCircular.titleAndCountdown.rawValue, displayName: "Event Title + Countdown", supportedFamilies: [CLKComplicationFamily.graphicCircular]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicCircular.icon.rawValue, displayName: "Icon", supportedFamilies: [CLKComplicationFamily.graphicCircular]),
        
        // Graphic Rectangular
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicRectangular.progressBar.rawValue, displayName: "Countdown + Progress Bar", supportedFamilies: [CLKComplicationFamily.graphicRectangular]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.GraphicRectangular.eventLocation.rawValue, displayName: "Countdown + Info", supportedFamilies: [CLKComplicationFamily.graphicRectangular]),
        
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
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.ModularLarge.countdown.rawValue, displayName: "Countdown + Info", supportedFamilies: [CLKComplicationFamily.modularLarge]),
        
        CLKComplicationDescriptor(identifier: ComplicationIdentifier.ModularLarge.largeCountdown.rawValue, displayName: "Large Countdown", supportedFamilies: [CLKComplicationFamily.modularLarge]),
        
        
    ]

    
    static func updateComplications() {
        
        let timeline = ComplicationController.timelineGen.generateTimelineItems(fast: false, percentages: false, forState: .normal)
        
        ComplicationController.timeline = timeline
        HLLDefaults.complication.latestTimeline = timeline.getCodableTimeline()
        ComplicationController.updates += 1
        print("Updating complication now: \(ComplicationController.updates)")
        
        let state = ComplicationController.timelineGen.shouldUpdate()
        
        switch state {
        case .noUpdateNeeded:
            print("Not Updating Complication")
        case .needsReloading:
            print("Reloading Complication")
            CLKComplicationServer.sharedInstance().activeComplications?.forEach({ CLKComplicationServer.sharedInstance().reloadTimeline(for: $0) })
        case .needsExtending:
            print("Extending Complication")
            CLKComplicationServer.sharedInstance().activeComplications?.forEach({ CLKComplicationServer.sharedInstance().extendTimeline(for: $0) })
        }
        
    }
    
    static func updateDescriptors() {
        
        CLKComplicationServer.sharedInstance().reloadComplicationDescriptors()
        
        Task {
            ComplicationController.updateComplications()
        }
        
    }
    
    override init() {
        
        print("Init Complication Controller")

        
        super.init()
        
        
    }
    
    func timelineEntries(complication: CLKComplication, date: Date?, limit: Int? = nil) -> [CLKComplicationTimelineEntry] {
        
        if HLLDefaults.watch.complicationEnabled == false {
            let template = entryGenerator.generateNotEnabledComplicationTemplate(complication: complication)
            
            var returnArray = [CLKComplicationTimelineEntry]()
            if let template = template {
                returnArray.append(CLKComplicationTimelineEntry(date: date ?? Date(), complicationTemplate: template))
            }
            
            return returnArray
            
        }
        
      
        
        var timelineEntries = ComplicationController.timeline.entriesAfterDate(date)
        if let limit = limit {
            timelineEntries = Array(timelineEntries.prefix(limit))
        }
        let complicationEntires = timelineEntries.compactMap({
            entryGenerator.getTimelineEntryComplicationEntry(complication: complication,timelineEntry: $0)
        })
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
            handler(ComplicationController.timeline.entries.last!.showAt)
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
        
        handler(timelineEntries(complication: complication, date: Date()).first)
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    
        print("First entry is at: \(ComplicationController.timeline.entries.first!.showAt.formattedTime(seconds: true)), reuqested: \(date.formattedTime(seconds: true))")
        
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
