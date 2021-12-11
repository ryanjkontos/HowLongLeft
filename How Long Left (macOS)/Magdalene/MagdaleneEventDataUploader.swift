//
//  MagdaleneEventDataUploader.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 28/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

/*

class MagdaleneEventDataUploader: EventPoolUpdateObserver {
    
    let eval = SchoolEventDownloadNeededEvaluator()
    
    init() {
        
        HLLEventSource.shared.addEventPoolObserver(self)
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
                
                let events = HLLEventSource.shared.eventPool
                
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
    
    func eventPoolUpdated() {
        self.run()
    }
    
    
    
    
    
}
*/
