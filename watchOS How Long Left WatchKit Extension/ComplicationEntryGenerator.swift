//
//  ComplicationEntryGenerator.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 6/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import ClockKit
import SwiftUI

class ComplicationEntryGenerator {
    
    func getTimelineEntryComplicationEntry(complication: CLKComplication, timelineEntry: HLLTimelineEntry) -> CLKComplicationTimelineEntry? {
        
        if let data = ComplicationProviderData(timelineEntry) {
            guard let template = generateComplicationTemplate(complication: complication, data: data) else { return nil }
            return CLKComplicationTimelineEntry(date: timelineEntry.getAdjustedShowAt(), complicationTemplate: template)
        } else {
            guard let template = generateNoEventComplicationTemplate(complication: complication) else { return nil }
            return CLKComplicationTimelineEntry(date: timelineEntry.getAdjustedShowAt(), complicationTemplate: template)
        }
        
    }
    
    func generateComplicationTemplate(complication: CLKComplication, data: ComplicationProviderData) -> CLKComplicationTemplate? {
        
        
        var template: CLKComplicationTemplate?
        
        switch complication.family {
            
        case .modularSmall:
            return nil
        case .modularLarge:
            
            let complicationType = ComplicationIdentifier.ModularLarge(rawValue: complication.identifier) ?? .countdown
            
            if complicationType == .largeCountdown {
                
                template = CLKComplicationTemplateModularLargeTallBody(headerTextProvider: data.firstRowProvider, bodyTextProvider: data.timerProvider)
                
            } else {
                template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: data.firstRowProvider, body1TextProvider: data.timerProvider, body2TextProvider: data.infoTextProvider)
            }
          
        case .utilitarianSmall:
            
            template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: data.fullTimerProvider)
            
        case .utilitarianSmallFlat:
            
            template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: data.fullTimerProvider)
            
        case .utilitarianLarge:
            
            if let oneLine = data.titleAndCountdownProvider {
                template = CLKComplicationTemplateUtilitarianLargeFlat(textProvider: oneLine)
                
            }
            
            
        case .circularSmall:
            
          //  template = CLKComplicationTemplateCircularSmallSimpleText(textProvider: "00:00".simpleTextProvider())
            
         //   template = CLKComplicationTemplateCircularSmallStackText(line1TextProvider: "in".simpleTextProvider(), line2TextProvider: "00:00".simpleTextProvider())
            
            
           
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 60, weight: .bold, scale: .large)
            
            var image = UIImage(systemName: "clock", withConfiguration: symbolConfig)!
            
            image = image.withHorizontallyFlippedOrientation()
            
            let imageProvider = CLKImageProvider(onePieceImage: image)
            
            template = CLKComplicationTemplateCircularSmallSimpleImage(imageProvider: imageProvider)
            
            
        case .extraLarge:
            return nil
        case .graphicCorner:
            
            let complicationType = ComplicationIdentifier.GraphicCorner(rawValue: complication.identifier) ?? .progressRing
            
           
            
            let stackProvider = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: data.eventTitleProvider, outerTextProvider: data.fullTimerProvider)
            
            switch complicationType {
            case .progressRing:
                
                if let gaugeProvider = data.gaugeProvider {
                    template = CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gaugeProvider, leadingTextProvider: data.eventTitleProvider, trailingTextProvider: nil, outerTextProvider: data.timerProvider)
                    
                    
                } else {
                    template = stackProvider
                }
                
            case .titleAndCountdown:
                
                template = stackProvider
                
            
            case .icon:
                
                template = CLKComplicationTemplateGraphicCornerCircularView(ComplicationIconView(isInGauge: false, isInXL: false, invertedForeground: false, fullColorTint: data.fullColorTint))
                
             //   template = CLKComplicationTemplateGraphicCornerCircularImage(imageProvider: CLKFullColorImageProvider(fullColorImage: UIImage(named: "ComplicationImage_GraphicCircular")!))
                
            }
            
        case .graphicBezel:
            
            let complicationType = ComplicationIdentifier.GraphicBezel(rawValue: complication.identifier) ?? .countdownAndProgressRing
                //let imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "ComplicationImage_GraphicCircular_Gauge")!)
            
            let iconProvider = CLKComplicationTemplateGraphicCircularView(ComplicationIconView(isInGauge: false, isInXL: false, invertedForeground: false, fullColorTint: data.fullColorTint))
            
           
            
            var circularTemplate: CLKComplicationTemplateGraphicCircular
            
            
            switch complicationType {
            case .countdownAndProgressRing:
                
                if let gaugeProvider = data.gaugeProvider {
                    
                    circularTemplate = CLKComplicationTemplateGraphicCircularClosedGaugeView(gaugeProvider: gaugeProvider, label: ComplicationIconView(isInGauge: true, isInXL: false, invertedForeground: false, fullColorTint: data.fullColorTint))
                    
                  
                } else {
                    circularTemplate = iconProvider
                }

            
                template = CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circularTemplate, textProvider: data.titleAndCountdownProvider)
                
            case .titleAndCountdown:
                
                circularTemplate = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: "".simpleTextProvider(), line2TextProvider: data.timerProvider)
                
                template = CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: circularTemplate, textProvider: "Event ends in".simpleTextProvider())
                
            case .icon:
                template = CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: iconProvider)
            }
            
    
            
            
        case .graphicCircular:
            
            let complicationType = ComplicationIdentifier.GraphicCircular(rawValue: complication.identifier) ?? .titleAndCountdown
                //let imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "ComplicationImage_GraphicCircular_Gauge")!)
            
            let stackProvider = CLKComplicationTemplateGraphicCircularStackText(line1TextProvider: data.eventTitleProvider, line2TextProvider: data.timerProvider)
            
            switch complicationType {
            case .progressRing:
                
                if let gaugeProvider = data.gaugeProvider {
                    
                    template = CLKComplicationTemplateGraphicCircularClosedGaugeView(gaugeProvider: gaugeProvider, label: ComplicationIconView(isInGauge: true, isInXL: false, invertedForeground: false, fullColorTint: data.fullColorTint))
                    
                   
                    
                   // template = CLKComplicationTemplateGraphicCircularClosedGaugeImage(gaugeProvider: gaugeProvider, imageProvider: imageProvider)
                } else {
                    template = stackProvider
                }
                
            case .titleAndCountdown:
                
                template = stackProvider
                
            
            case .icon:
                
                template = CLKComplicationTemplateGraphicCircularView(ComplicationIconView(isInGauge: false, isInXL: false, invertedForeground: true, fullColorTint: data.fullColorTint))
            }
            
        case .graphicRectangular:
            
            let complicationType = ComplicationIdentifier.GraphicRectangular(rawValue: complication.identifier) ?? .progressBar
            
            let secondRowProvider: CLKTextProvider = data.fullTimerProvider
            
            var gaugeAllowed = true
            if let underlying = data.underlyingTimelineEntry {
                if underlying.showInfoIfAvaliable {
                    gaugeAllowed = false
                }
            }
        
            if complicationType == .largeCountdown {
                
                template = CLKComplicationTemplateGraphicRectangularLargeView(headerTextProvider: data.firstRowProvider, content: LargeCountdownComplicationView(provider: data.timerProvider))
                
            } else if let gaugeProvider = data.gaugeProvider, complicationType == .progressBar, gaugeAllowed {
                template = CLKComplicationTemplateGraphicRectangularTextGauge(headerTextProvider: data.firstRowProvider, body1TextProvider: secondRowProvider, gaugeProvider: gaugeProvider)
            } else {
                template = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: data.firstRowProvider, body1TextProvider: secondRowProvider, body2TextProvider: data.infoTextProvider)
            }
            
            
        case .graphicExtraLarge:
            
            let complicationType = ComplicationIdentifier.GraphicExtraLarge(rawValue: complication.identifier) ?? .titleAndCountdown
                //let imageProvider = CLKFullColorImageProvider(fullColorImage: UIImage(named: "ComplicationImage_GraphicCircular_Gauge")!)
            
            
            let stackProvider = CLKComplicationTemplateGraphicExtraLargeCircularStackText(line1TextProvider: data.eventTitleProvider, line2TextProvider: data.timerProvider)
            
            switch complicationType {
            case .progressRing:
                
                if let gaugeProvider = data.gaugeProvider {
                    
                    
                    template = CLKComplicationTemplateGraphicExtraLargeCircularClosedGaugeView(gaugeProvider: gaugeProvider, label: ComplicationIconView(isInGauge: true, isInXL: true, invertedForeground: true, fullColorTint: data.fullColorTint))
                    
                   
                    
                   // template = CLKComplicationTemplateGraphicCircularClosedGaugeImage(gaugeProvider: gaugeProvider, imageProvider: imageProvider)
                } else {
                    template = stackProvider
                }
                
            case .titleAndCountdown:
                
                template = stackProvider
                
            
            case .icon:
                template = CLKComplicationTemplateGraphicExtraLargeCircularView(ComplicationIconView(isInGauge: false, isInXL: true, invertedForeground: true, fullColorTint: data.fullColorTint))
            }
            
        @unknown default:
            return nil
        }
        
        return template
        
        
    }
    
    func generateNoEventComplicationTemplate(complication: CLKComplication) -> CLKComplicationTemplate? {
        
        var template: CLKComplicationTemplate?
        
        switch complication.family {
            
        case .modularSmall:
            return nil
        case .modularLarge:
            return nil
        case .utilitarianSmall:
            return nil
        case .utilitarianSmallFlat:
            return nil
        case .utilitarianLarge:
            return nil
        case .circularSmall:
            return nil
        case .extraLarge:
            return nil
        case .graphicCorner:
            return nil
        case .graphicBezel:
            return nil
        case .graphicCircular:
            
            template = CLKComplicationTemplateGraphicCircularView(ComplicationIconView(isInGauge: false, isInXL: false, invertedForeground: false))
            
        case .graphicRectangular:
            
            let header = "How Long Left".simpleTextProvider()
            header.tintColor = .orange
            
            let body1 = "No Event".simpleTextProvider()
            
            template = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: header, body1TextProvider: body1)
            
        case .graphicExtraLarge:
            return nil
        @unknown default:
            return nil
        }
        
        return template
        
    }
    
    func generateNotEnabledComplicationTemplate(complication: CLKComplication) -> CLKComplicationTemplate? {
        
        var template: CLKComplicationTemplate?
        
        switch complication.family {
            
        case .modularSmall:
            return nil
        case .modularLarge:
            return nil
        case .utilitarianSmall:
            return nil
        case .utilitarianSmallFlat:
            return nil
        case .utilitarianLarge:
            return nil
        case .circularSmall:
            return nil
        case .extraLarge:
            return nil
        case .graphicCorner:
            
          
            template = CLKComplicationTemplateGraphicCornerCircularView(ComplicationIconView(isInGauge: false, isInXL: false, invertedForeground: true, fullColorTint: .orange))
            
        case .graphicBezel:
            
            return nil
            
        case .graphicCircular:
            
            template = CLKComplicationTemplateGraphicCircularView(ComplicationIconView(isInGauge: false, isInXL: false, invertedForeground: false))
            
        case .graphicRectangular:
            
            let header = "How Long Left".simpleTextProvider()
            header.tintColor = .orange
            
            let body1 = "Complication Not Activated".simpleTextProvider()
            
            template = CLKComplicationTemplateGraphicRectangularStandardBody(headerTextProvider: header, body1TextProvider: body1)
            
        case .graphicExtraLarge:
            return nil
        @unknown default:
            return nil
        }
        
        return template
        
    }
    
}

extension String {
    
    func simpleTextProvider() -> CLKSimpleTextProvider {
        
        return CLKSimpleTextProvider(text: self)
        
    }
    
}
