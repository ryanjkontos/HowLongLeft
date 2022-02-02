//
//  HLLHiddenEvent+CoreDataClass.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/5/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//
//

import Foundation
import CoreData

//@objc(HLLHiddenEvent)
public class HLLStoredEvent: NSManagedObject {
    
    func setup(from event: HLLEvent) {
        
        self.title = event.title
        
        if let ekID = event.eventIdentifier {
           self.identifier = ekID
        } else {
            self.identifier = event.persistentIdentifier
        }
        
        self.calendarIdentifier = event.calendarID
        self.endDate = event.endDate
        
    }

}
