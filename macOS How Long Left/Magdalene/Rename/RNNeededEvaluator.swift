//
//  RNNeededEvaluator.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 26/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation



/*class RNNeededEvaluator: EventSourceUpdateObserver {
    
    let termFetcher = TermEventFetcher()
    let schoolAnalyser = SchoolAnalyser()
    
    init() {
        HLLEventSource.shared.addeventsObserver(self)
    }
    
    func evaluateRenameNeeded() {
        
        DispatchQueue.global().async {
        
            RNUIManager.shared.promptToRenameIfNeeded(); return
            
        if SchoolAnalyser.schoolMode == .Magdalene {
                
            if !self.schoolAnalyser.magdaleneTitles(from: HLLEventSource.shared.events, includeRenamed: false).isEmpty {
                    
                    RNUIManager.shared.promptToRenameIfNeeded()
                    
                }
            
            }
            
        }
        
    }
    
    func eventsUpdated() {
        evaluateRenameNeeded()
    }
    
}
*/
