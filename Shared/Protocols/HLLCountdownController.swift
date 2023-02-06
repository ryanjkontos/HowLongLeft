//
//  HLLCountdownController.swift
//  How Long Left
//
//  Created by Ryan Kontos on 6/2/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

protocol HLLCountdownController {
    
    /**
     * Called when a HLLEvent has ended.
     */
    
    func updateDueToEventEnd(event: HLLEvent, endingNow: Bool)
    func milestoneReached(milestone seconds: Int, event: HLLEvent)
    func percentageMilestoneReached(milestone percentage: Int, event: HLLEvent)
    func eventStarted(event: HLLEvent)
    
}
