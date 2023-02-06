//
//  Calendar.swift
//  How Long Left
//
//  Created by Ryan Kontos on 25/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation

extension Calendar {
    
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
            
        return numberOfDays.day!
    }
    
}
