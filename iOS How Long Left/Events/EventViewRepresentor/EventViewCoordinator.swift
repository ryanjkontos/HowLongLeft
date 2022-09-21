//
//  EventViewCoordinator.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 18/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

class EventViewCoordinator {
    
    init(_ parent: EventViewRepresentor) {
        self.representor = parent
    }
    
    var representor: EventViewRepresentor
    
    func beginNicknaming() {
        representor.startNicknaming()
    }
    
    func updateEventSource() {
        
        representor.eventSource?.update(force: false)
        
    }
    
}
