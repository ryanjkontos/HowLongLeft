//
//  HSCEventFetcher.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 7/2/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HSCEventFetcher {
    
    static var shared = HSCEventFetcher()
    
   
    
    func getHSCEvent() -> HLLEvent? {
        
        if SchoolAnalyser.schoolMode == .Magdalene, HLLDefaults.magdalene.showHSC {

            var startComponents = DateComponents()
                   startComponents.year = 2020
                   startComponents.month = 10
                   startComponents.day = 20
                   startComponents.hour = 00
                   startComponents.minute = 00
                   startComponents.second = 00
                   let start = (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: startComponents))!
                        
                        var endComponents = DateComponents()
                        endComponents.year = 2020
                        endComponents.month = 11
                        endComponents.day = 11
                        endComponents.hour = 00
                        endComponents.minute = 00
                        endComponents.second = 00
                        let end = (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: endComponents))!
                        
                        var event = HLLEvent(title: "HSC Exams", start: start, end: end, location: nil)
                       event.keepInTopShelf = true
                       event.visibilityString = VisibilityString.hsc
                        event.titleReferencesMultipleEvents = true
                   
            return event
        }
        
        return nil
        
        
    }
    
}


