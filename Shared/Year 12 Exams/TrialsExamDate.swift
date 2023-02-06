//
//  TrialsExamDate.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 29/7/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class TrialsExamDate: ExamDate {
    
    
    private var trialsDay: TrialsDay
    private var trialsSession: TrialsSession
    private var length: Double
    
    init(_ day: TrialsDay, session: TrialsSession, durationHours: Double) {
        
        self.trialsDay = day
        self.trialsSession = session
        self.length = durationHours*3600
        
    }
    
    var startDate: Date {
        
        get {
          
            var components = DateComponents()
            components.year = 2020
                          
            let dayAndMonth = gerDayAndMonthFor(trialsDay: self.trialsDay)
                   
            components.day = dayAndMonth.day
            components.month = dayAndMonth.month
                   
             let hourAndMinute = getHourAndMinuteFor(session: self.trialsSession)
                   
            components.hour = hourAndMinute.hour
            components.minute = hourAndMinute.minute
                   
            return (NSCalendar(identifier: NSCalendar.Identifier.gregorian)?.date(from: components))!
            
        }
        
        
    }
    
    var endDate: Date {
    
    get {
      
        self.startDate.addingTimeInterval(self.length)
        
    }
    
    }
    
    func gerDayAndMonthFor(trialsDay: TrialsDay) -> (day: Int, month: Int) {
        
        switch trialsDay {
            
        case .monday1:
            return (17, 8)
        case .tuesday1:
            return (18, 8)
        case .wednesday1:
            return (19, 8)
        case .thursday1:
            return (20, 8)
        case .friday1:
            return (21, 8)
        case .monday2:
            return (24, 8)
        case .tuesday2:
            return (25, 8)
        case .wednesday2:
            return (26, 8)
        case .thursday2:
            return (27, 8)
        case .friday2:
            return (28, 8)
        case .monday3:
            return (31, 8)
        }
        
    }
    
    func getHourAndMinuteFor(session: TrialsSession) -> (hour: Int, minute: Int) {
        
        switch session {
            
        case .morning:
            return (8, 00)
        case .afternoon:
            return (13, 00)
        }
        
    }
    
    
}
