//
//  CurrentDateFetcher.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 2/2/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class CurrentDateFetcher {
    
    static private var date: Date?
    
    static var currentDate: Date {
        
        get {
            
            //if CurrentDateFetcher.date == nil {
             //   CurrentDateFetcher.date = Date(timeIntervalSince1970: 1168296060)
           // }
            
          //  return CurrentDateFetcher.date!
            
            return Date()
            
        }
        
    }
    
}
