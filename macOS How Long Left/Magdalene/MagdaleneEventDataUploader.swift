//
//  MagdaleneEventDataUploader.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

/*

class MagdaleneEventDataUploader: EventSourceUpdateObserver {
    
    let eval = SchoolEventDownloadNeededEvaluator()
    
    init() {
        
        HLLEventSource.shared.addeventsObserver(self)
    }
    
    func run() {
        
        if SchoolAnalyser.schoolMode != .Magdalene {
            return
        }
        
        DispatchQueue.global().async {
        
        if HLLDefaults.defaults.bool(forKey: "UTitles") == false {
        
            if self.eval.evaluateSchoolEventDownloadNeeded() == .notNeeded {
                
                var titles = Set<String>()
                var teachers = Set<String>()
                
                let events = HLLEventSource.shared.events
                
                for event in events {
                    
                    if event.isSchoolEvent {
                        
                        titles.insert(event.originalTitle)
                        
                        if let teacher = event.teacher {
                            teachers.insert(teacher)
                        }
                        
                    }
                    
                }
                
              
       
                
            }
            
            }
        
        }
            
    }
    
    func eventsUpdated() {
        self.run()
    }
    
    
    
    
    
}
*/
