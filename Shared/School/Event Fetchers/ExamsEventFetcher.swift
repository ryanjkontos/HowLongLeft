//
//  ExamsEventFetcher.swift
//  
//
//  Created by Ryan Kontos on 3/9/19.
//

import Foundation

class ExamEventFetcher {
    
    private var examEvent: HLLEvent?
    
    init() {
        
       var startComponents = DateComponents()
        startComponents.year = 2019
        startComponents.month = 9
        startComponents.day = 12
        startComponents.hour = 8
        startComponents.minute = 00
        startComponents.second = 00
        let start = (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: startComponents))!
        
        var endComponents = DateComponents()
        endComponents.year = 2019
        endComponents.month = 9
        endComponents.day = 24
        endComponents.hour = 14
        endComponents.minute = 35
        endComponents.second = 00
        let end = (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: endComponents))!
        
        var event = HLLEvent(title: "Prelims", start: start, end: end, location: nil)
        event.isPinned = true
        event.isPrelims = true
        event.visibilityString = VisibilityString.term
        event.titleReferencesMultipleEvents = true
        
        examEvent = event
        
    }
    
    func getExamEvent() -> HLLEvent? {
        
      
        
        if SchoolAnalyser.schoolMode == .Magdalene, HLLDefaults.magdalene.showPrelims {
            
            examEvent?.useSchoolCslendarColour = true
            return examEvent
        }
        
        return nil
        
        
    }
    
}
