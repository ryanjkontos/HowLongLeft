//
//  HLLHiddenEvent+CoreDataProperties.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/5/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//
//

import Foundation
import CoreData


extension HLLStoredEvent {



    func setup(from event: HLLEvent) {
        
        self.title = event.title
        
        if let ekID = event.eventIdentifier {
           self.identifier = ekID
        } else {
            self.identifier = event.persistentIdentifier
        }
        
        self.calendarIdentifier = event.calendarID
        self.endDate = event.endDate
        self.startDate = event.startDate
        
    }
    
    public var id: String { return identifier ?? "" }

}
