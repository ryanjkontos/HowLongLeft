//
//  EventDetailChangesModifier.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 18/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class EventDetailChangesModifier {
    
    func addChangesTo(events: [HLLEvent]) -> [HLLEvent] {
        
        return events
        
      /*  var returnArray = [HLLEvent]()
        
        let index = SchoolEventDetailIndexBuilder.shared.index
        
        for event in events {

            var returnEvent = event
            
            if let indexDetails = index[returnEvent.schoolEventIdentifier] {
                
                if let indexTeacher = indexDetails["teacher"], let eventTeacher = returnEvent.teacher {
                    
                    returnEvent.usualTeacher = indexTeacher
                    
                    if indexTeacher != eventTeacher {
                    
                        returnEvent.teacherChange = eventTeacher
                        
                    }
                    
                }
                
                if let indexRoom = indexDetails["location"], let eventRoom = returnEvent.location {
                    
                    returnEvent.usualRoom = indexRoom
                    
                    if indexRoom != eventRoom {
                    
                        returnEvent.roomChange = eventRoom
                        print("Set a room change! \(indexRoom) -> \(eventRoom)")
                        
                    }
                    
                }
                
            }
            
            returnArray.append(returnEvent)
            
        }
        
        return returnArray*/
        
    }
    
    
}
