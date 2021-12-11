//
//  SchoolAnalyser.swift
//  How Long Left
//
//  Created by Ryan Kontos on 18/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import EventKit

struct SchoolAnalyser {
    
    static var doneAnalysis = false
    static var isRenamerApp = false
    var delegate: SchoolModeChangedDelegate?
    static var termDates = [Date]()
    let searchWeeks = [46, 12, 24, 35, 46]
    public private(set) static var privSchoolMode: SchoolMode = .Unknown

    private var schoolModeChangedDelegates = [SchoolModeChangedDelegate]()
    static var schoolCalendar: EKCalendar? {
        
        get {
            
            if let title = HLLDefaults.defaults.string(forKey: "SchoolCalendar") {
                return HLLEventSource.shared.eventStore.calendars(for: .event).filter({$0.title == title}).first
            }
            
            return nil
            
        }
        
    }
    
    static var schoolMode: SchoolMode {
        
        get {
            
            if HLLDefaults.magdalene.manuallyDisabled {
                
             //   print("SA: Returning None")
                
                return .None
            }
            
            if SchoolAnalyser.doneAnalysis == false {
                
                if HLLDefaults.defaults.bool(forKey: "WasMagdalene") {
             //       print("SA: Returning Magdalene")
                    
                    return .Magdalene
                }
                
            }
            
            if privSchoolMode == .Magdalene {
            
            if HLLDefaults.magdalene.manuallyDisabled == false {
                
              //  print("SA: Returning \(privSchoolMode)")
                
                return privSchoolMode
                
            } else {
                
             //   print("SA: Returning .none")
                
                return .None
                
            }
                
            } else {
                
             //   print("SA: Returning \(privSchoolMode)")
                
                return privSchoolMode
                
            }
            
        }
        
        
    }
    
    static var isSchoolUser: Bool {
    
        get {
            
            if HLLDefaults.magdalene.manuallyDisabled == true {
                
                return false
                
            } else {
                
                if SchoolAnalyser.schoolMode == .Magdalene {
                    
                    return true
                    
                }
                
                return false
                
                
            }
            
        }
    
    
    }
    
    public private(set) static var privSchoolYear = SchoolYear.none
    
    static var schoolYear: SchoolYear {
        
        if SchoolAnalyser.schoolMode == .Magdalene {
            return privSchoolYear
        } else {
            return .none
        }
        
    }
    

    init() {
        
        if HLLDefaults.magdalene.magdaleneModeWasEnabled {
            
            SchoolAnalyser.privSchoolMode = .Magdalene
        }
        
        for (index, week) in searchWeeks.enumerated() {
            
            var doPreviousYear = false
            
            if index == 0 {
                
                doPreviousYear = true
                
            }
            
            SchoolAnalyser.termDates.append(getWednesdayFromWeek(weekNumber: week, previousYear: doPreviousYear))
            
        }
        
    }
    
    mutating func addSchoolMOdeChangedDelegate<T>(delegate: T) where T: SchoolModeChangedDelegate, T: Equatable {
        schoolModeChangedDelegates.append(delegate)
    }
    
    mutating func setLoneDelegate(to: SchoolModeChangedDelegate) {
        
        delegate = to
        
    }
    
    mutating func removeSchoolModeChangedDelegate<T>(delegate: T) where T: SchoolModeChangedDelegate, T: Equatable {
        for (index, schoolModeDelegate) in schoolModeChangedDelegates.enumerated() {
            if let schoolModeDelegate = schoolModeDelegate as? T, schoolModeDelegate == delegate {
                schoolModeChangedDelegates.remove(at: index)
                break
            }
        }
    }

    
    
    
    func analyseCalendar(inputEvents: [HLLEvent]) {
        
          var analysisEvents = inputEvents
          
        let previousMode = SchoolAnalyser.privSchoolMode
                 
          for date in SchoolAnalyser.termDates {
                     
            analysisEvents.append(contentsOf: HLLEventSource.shared.getEventsFromCalendar(start: date.startOfDay().addingTimeInterval(29640), end: date.startOfDay().addingTimeInterval(52560)))
                     
          }

        
        let events = analysisEvents.sorted(by: { $0.startDate.compare($1.startDate) == .orderedDescending })
        

        if events.isEmpty {
            
            SchoolAnalyser.privSchoolMode = .Unknown
            return
            
        }
        
        let isMagdalene = self.analyseForMagdalene(events: events)
        
        HLLDefaults.defaults.set(isMagdalene, forKey: "WasMagdalene")
        
        
        if isMagdalene == true {
            
            SchoolAnalyser.privSchoolMode = .Magdalene
            
            
        } else {
            SchoolAnalyser.privSchoolMode = .None
            
        }
        
        SchoolAnalyser.doneAnalysis = true
        
        if SchoolAnalyser.privSchoolMode != previousMode {
            HLLEventSource.shared.asyncUpdateEventPool()
        }
        
    }
    
    private func analyseForMagdalene(events: [HLLEvent]) -> Bool {
        
        // Analyses calendar events and determines if the user goes to Magdalene or not.
        
        var returnVal = false
        
        var startDates = [String]()
        var endDates = [String]()
        
        var numberArray = [Int]()
        
        for event in events {
            
            startDates.append(event.startDate.formattedTimeTwelve())
            endDates.append(event.endDate.formattedTimeTwelve())
            
            var intString = ""
            
            for character in event.title {
                
                if intString.count > 1 {
                    break
                }
                
                if character.isASCII, character.isNumber {
                    intString += "\(character)"
                } else {
                    break
                }
                
            
                
            }
            
            if let intValue = Int(intString) {
                
                numberArray.append(intValue)
                
            }
            
            
            
        }
        
        let countedSet = NSCountedSet(array: numberArray)
        if let mostFrequent = (countedSet.max { countedSet.count(for: $0) < countedSet.count(for: $1) } as? Int), let year = SchoolYear(rawValue: mostFrequent) {
            
            print("School year is now Year \(mostFrequent).")
            SchoolAnalyser.privSchoolYear = year
            
        } else {
            SchoolAnalyser.privSchoolYear = .none
        }
    
        
        let titles = self.magdaleneTitles(from: events, includeRenamed: true)
        
        if titles.isEmpty == false, startDates.contains("8:15am"), endDates.contains("2:35pm") {
            returnVal = true
        }
        
        
        #if targetEnvironment(simulator)
        returnVal = true
        #endif
        
        #if !os(watchOS)
        
        let previousValue = HLLDefaults.defaults.bool(forKey: "MagdaleneModeiOS")
        
        if returnVal != previousValue {
            HLLDefaults.defaults.set(returnVal, forKey: "MagdaleneModeiOS")
            HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
        }
        
        #else
        
        if HLLDefaults.defaults.bool(forKey: "MagdaleneModeiOS") {
            return true
        }
        
        #endif
        
        return returnVal
        
    }
    
    func magdaleneTitles(from events: [HLLEvent], includeRenamed: Bool = false) -> [String] {
           
            var titles = [String]()
           
            var schoolCalendar: EKCalendar?
            
           let sorted = events.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
           
           for event in sorted {
 
            
            if event.isSchoolEvent {
                    
                  titles.append(event.originalTitle)
                schoolCalendar = event.calendar
            
            }


               
           }
        
        if let calendar = schoolCalendar {
        
        if HLLDefaults.defaults.string(forKey: "SchoolCalendar") != calendar.title {
            HLLDefaults.defaults.set(calendar.title, forKey: "SchoolCalendar")
            HLLDefaultsTransfer.shared.userModifiedPrferences()
        }
            
        }
           
           return titles
           
       }
    
    func hasMagdaleneTitles(in events: [HLLEvent], includeRenamed: Bool) -> Bool {
        return !magdaleneTitles(from: events, includeRenamed: includeRenamed).isEmpty
    }
    
    func getWednesdayFromWeek(weekNumber: Int, previousYear: Bool) -> Date {
        
        let calendar = NSCalendar.current
        var currentYear = calendar.component(.year, from: CurrentDateFetcher.currentDate)
        
        if previousYear == true {
            
            currentYear -= 1
            
        }
        
        let Calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let dayComponent = NSDateComponents()
        dayComponent.weekOfYear = weekNumber
        dayComponent.weekday = 4
        dayComponent.year = currentYear
        var date = Calendar.date(from: dayComponent as DateComponents)
        
        if(weekNumber == 1 && Calendar.components(.month, from: date!).month != 1){
            dayComponent.year = currentYear-1
            date = Calendar.date(from: dayComponent as DateComponents)
        }
        
        return date!
    }
    
    func getNextSchoolSearchCurrentDate() -> Date {
        
        var upcomingDates = [Date]()
        for date in SchoolAnalyser.termDates {
            if date.timeIntervalSince(CurrentDateFetcher.currentDate) > 0 { upcomingDates.append(date) }
        }
        upcomingDates.sort(by: { $0.compare($1) == .orderedAscending })
        return upcomingDates.first!
        
    }
    
}

protocol SchoolModeChangedDelegate {
    func schoolModeChanged()
}

enum SchoolYear: Int {
    
    case none = 0
    case year7 = 7
    case year8 = 8
    case year9 = 9
    case year10 = 10
    case year11 = 11
    case year12 = 12
    
}
