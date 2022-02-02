//
//  HLLEventInfoItemGenerator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

/**
* Fetch HLLEventInfoItem objects that describe a HLLEvent in a user friendly way.
*/

class HLLEventInfoItemGenerator {
    
    private var event: HLLEvent
    
    init(_ event: HLLEvent) {
        self.event = event
    }
    
    private let durationStringGenerator = DurationStringGenerator()
    private let percentageCalculator = PercentageCalculator()
    private let countdwonStringGenerator = CountdownStringGenerator()
    
    func getInfoItem(for type: HLLEventInfoItemType) -> HLLEventInfoItem? {
        
        var titleString: String?
        var infoString: String?
        
        switch type {
            
        case .completion:
        
            if event.completionStatus == .current {
            titleString = "Completion"
            infoString = percentageCalculator.calculatePercentageDone(for: event)
            }
            
        case .location:
            
            titleString = "Location"
            
            if let location = event.location {
                
                infoString = location

                
            }
            
        case .start:
            
           titleString = "Start"
           if event.completionStatus != .upcoming {
                titleString = "Started"
           }
           
           infoString = "\(event.startDate.userFriendlyRelativeString()), \(event.startDate.formattedTime())"
            
        case .end:
            
            titleString = "End"
            if event.completionStatus == .done {
                titleString = "Ended"
            }
            
            infoString = "\(event.endDate.userFriendlyRelativeString()), \(event.endDate.formattedTime())"
            
        case .elapsed:
        
            if event.completionStatus == .current {
            
                    titleString = "Elapsed"
                    let secondsSinceStart = CurrentDateFetcher.currentDate.timeIntervalSince(event.startDate)
                    infoString = durationStringGenerator.generateDurationString(for: secondsSinceStart)
                    
                }
                
                if event.completionStatus == .done {
                    
                    titleString = "Finshed"
                    let secondsSinceEnd = CurrentDateFetcher.currentDate.timeIntervalSince(event.endDate)
                    let duration = durationStringGenerator.generateDurationString(for: secondsSinceEnd)
                    infoString = "\(duration) ago"
                    
                }
            
        case .duration:
            
            titleString = "Duration"
            infoString = durationStringGenerator.generateDurationString(for: event.duration)
            
        case .calendar:
            
            titleString = "Calendar"
            if let calendar = event.calendar {
                infoString = calendar.title
            }

        case .nextOccurence:
            
            titleString = "Following Occurrence"
            
            if HLLDefaults.general.showNextOccurItems == false {
                return nil
            }

            
        case .countdown:
            
            if event.completionStatus != .done {
            
            titleString = "\(event.countdownTypeString.capitalizingFirstLetter()) in"
            infoString = countdwonStringGenerator.generatePositionalCountdown(event: event)
                
            }
   
        }
        
        if let title = titleString, let info = infoString {
            return HLLEventInfoItem(title, info, type)
        } else {
            return nil
        }
        
    }
    
    func getInfoItems(for types: [HLLEventInfoItemType]) -> [HLLEventInfoItem] {
        
        var returnArray = [HLLEventInfoItem]()
        
        for type in types {
            
            if let item = getInfoItem(for: type) {
               
                returnArray.append(item)
                
            }
            
        }
        
        return returnArray
        
    }

}
