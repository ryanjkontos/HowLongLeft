//
//  FollowingOccurenceStore.swift
//  How Long Left
//
//  Created by Ryan Kontos on 30/11/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class FollowingOccurenceStore {

    static var shared = FollowingOccurenceStore()
    
    let barrierQueue = DispatchQueue(label: "EventNextOccurenceStoreBarrierQueue")
    
    var nextOccurDictionary = [String:HLLEvent]()
    
    func updateNextOccurenceDictionary(events: [HLLEvent]) {
        
        var returnDict = [String:HLLEvent]()
        
        if HLLDefaults.general.showNextOccurItems == false {
            self.nextOccurDictionary.removeAll()
            return
        }
        
        let eventsTemp = events
        
        let sorted = eventsTemp.sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        
        for outerEvent in sorted {
            
            
            
            let dif = CurrentDateFetcher.currentDate.timeIntervalSince(outerEvent.startDate)
            
            for innerEvent in sorted {

                
                
                let difFromEvent = innerEvent.endDate.timeIntervalSince(outerEvent.startDate)
                
                if innerEvent.title == outerEvent.title, returnDict.keys.contains(innerEvent.persistentIdentifier) == false, dif < 0, innerEvent.startDate != outerEvent.startDate, innerEvent.endDate != outerEvent.endDate, difFromEvent < 0, outerEvent.completionStatus == .upcoming {
                        returnDict[innerEvent.persistentIdentifier] = outerEvent

                }
                
            }
                
        }
           
        self.nextOccurDictionary = returnDict

        
    }
    
    
}


