//
//  UpcomingEventScreenInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 26/1/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import UIKit
import WatchKit

class UpcomingEventScreenInterfaceController: WKInterfaceController {
    
    
    @IBOutlet var eventTitleLabel: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        
        if let event = context as? HLLEvent {
            
            print("Finished segue with \(event.title)")
            
            eventTitleLabel.setText(event.title)
                
                if let cal = EventDataSource.shared.calendarFromID(event.calendarID) {
                
                eventTitleLabel.setTextColor(UIColor(cgColor: cal.cgColor))
                    
                }
            
            
            
            
        }
        
    }
    

}
