//
//  BackgroundUpdateHandler.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 16/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import WatchKit
import ClockKit

class BackgroundUpdateHandler {
    let complication = CLKComplicationServer.sharedInstance()
    let defaults = HLLDefaults.defaults
    
    func scheduleComplicationUpdate() {
        
        
      /*  let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let fDate = dateFormatterPrint.string(from: Date())
        
        if let lastUpdate = defaults.string(forKey: "lastUpdate") {
            
            if lastUpdate == fDate {
                
                return
                
            }
            
        } */
        
        
        var date = Date()

           date = date.addingTimeInterval(2700)
          //  date = date.addingTimeInterval(120)
            self.defaults.set("\(date.timeIntervalSinceReferenceDate)", forKey: "lastUpdateScheduled")
            
           // // print(date)
            
            WKExtension.shared().scheduleBackgroundRefresh(withPreferredDate: date, userInfo: "UpdateComplication" as NSSecureCoding & NSObjectProtocol, scheduledCompletion: {Error in
                
                if let e = Error {
                    
                    // print("Failed to scheduled complication update due to \(e)")
                    
                } else {
                    
                    // print("Scheduled complication update")
                    
                }
                
                
                
            })
            
        
        
    }
    
}
