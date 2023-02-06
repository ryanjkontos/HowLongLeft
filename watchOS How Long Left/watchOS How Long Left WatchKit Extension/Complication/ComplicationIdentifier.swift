//
//  ComplicationIdentifier.swift
//  watchOS How Long Left WatchKit Extension
//
//  Created by Ryan Kontos on 17/1/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

struct ComplicationIdentifier {
    
    enum GraphicCircular: String {
        case progressRing = "HLLComplication.graphicCircular.progressRing"
        case titleAndCountdown = "HLLComplication.graphicCircular.eventTitleAndCountdown"
        case icon = "HLLComplication.graphicCircular.icon"
    }
    
    enum UtilitarianLarge: String {
        
        case titleAndCountdown = "HLLComplication.utilitarianLarge.eventTitleAndCountdown"
        
    }
    
    enum UtilitarianSmall: String {
        
        case titleAndCountdown = "HLLComplication.utilitarianSmall.countdown"
        
    }
    
    enum UtilitarianSmallFlat: String {
        
        case countdown = "HLLComplication.utilitarianSmallFlat.countdown"
        
    }
    
    enum GraphicExtraLarge: String {
        case progressRing = "HLLComplication.graphicXL.progressRing"
        case titleAndCountdown = "HLLComplication.graphicXL.eventTitleAndCountdown"
        case icon = "HLLComplication.graphicXL.icon"
    }
    
    enum GraphicRectangular: String {
        case largeCountdown = "HLLComplication.graphicRectangular.largeCountdown"
        case eventPlusInfo = "HLLComplication.graphicRectangular.eventPlusInfo"
    }
    
    enum ModularSmall: String {
        case countdown = "HLLComplication.modularSmall.countdown"
        
    }
    
    enum ModularLarge: String {
        case countdown = "HLLComplication.modularLarge.countdown"
        case largeCountdown = "HLLComplication.modularLarge.largeCountdown"
    }
    
    enum GraphicCorner: String {
        
        case progressRing = "HLLComplication.graphicCorner.progressRing"
        case titleAndCountdown = "HLLComplication.graphicCorner.eventTitleAndCountdown"
        case icon = "HLLComplication.graphicCorner.icon"
        
    }
    
    enum GraphicBezel: String {
        
        case countdownAndProgressRing = "HLLComplication.graphicCorner.progressRing"
        case titleAndCountdown = "HLLComplication.graphicCorner.eventTitleAndCountdown"
        case icon = "HLLComplication.graphicCorner.icon"
        
    }
    
    
}
