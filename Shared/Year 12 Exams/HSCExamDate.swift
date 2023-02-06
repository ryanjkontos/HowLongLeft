//
//  HSCExamDate.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HSCExamDate: ExamDate {
    
    var starthour: Int
    var startminute: Int
    var endhour: Int
    var endminute: Int
    private var hscDay: HSCDay
    
    
    init(_ day: HSCDay, starthour: Int, startminute: Int, endHour: Int, endMinute: Int) {
        
        self.hscDay = day
        self.starthour = starthour
        self.startminute = startminute
        self.endhour = endHour
        self.endminute = endMinute
        
    }
    
    var startDate: Date {
        
        get {
          
            var components = getComponentsFor(hscDay: self.hscDay)
            components.hour = self.starthour
            components.minute = self.startminute
            return (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: components))!
            
        }
        
        
    }
    
    var endDate: Date {
    
    get {
      
        var components = getComponentsFor(hscDay: self.hscDay)
        components.hour = self.endhour
        components.minute = self.endminute
        return (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: components))!
        
    }
    
    }
    
    
    func getComponentsFor(hscDay: HSCDay) -> DateComponents {
        
        var components = DateComponents()
        components.year = 2020
        
        
        switch hscDay {
            
        case .one:
            components.month = 10
            components.day = 20
        case .two:
            components.month = 10
            components.day = 21
        case .three:
            components.month = 10
            components.day = 22
        case .four:
            components.month = 10
            components.day = 23
        case .five:
            components.month = 10
            components.day = 26
        case .six:
            components.month = 10
            components.day = 27
        case .seven:
            components.month = 10
            components.day = 28
        case .eight:
            components.month = 10
            components.day = 29
        case .nine:
            components.month = 10
            components.day = 30
        case .ten:
            components.month = 11
            components.day = 2
        case .eleven:
            components.month = 11
            components.day = 3
        case .twelve:
            components.month = 11
            components.day = 4
        case .thirteen:
            components.month = 11
            components.day = 5
        case .fourteen:
            components.month = 11
            components.day = 6
        case .fifteen:
            components.month = 11
            components.day = 9
        case .sixteen:
            components.month = 11
            components.day = 10
        case .seventeen:
            components.month = 11
            components.day = 11
        }
        
        return components
        
    }

    
}
