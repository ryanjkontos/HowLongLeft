//
//  LiveActivityStore.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation
import ActivityKit

@available(iOS 16.1, *)
class LiveActivityStore {
    
    func getActivityForEvent(_ event: HLLEvent) -> Activity<LiveEventAttributes>? {
        
        let activities = Activity<LiveEventAttributes>.activities
        
        for activity in activities {
            
            if activity.attributes.event.persistentIdentifier == event.persistentIdentifier {
                return activity
            }
            
        }
        
        return nil
        
    }
    
    
    
    
}
