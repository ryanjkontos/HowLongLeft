//
//  HWShift.swift
//  HowLongLeftiOSNotificationContentExtension
//
//  Created by Ryan Kontos on 5/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import UserNotifications

struct HWShift: Identifiable, Equatable {
    
    var start: Date
    var end: Date
    
    var id: String {
        return String(start.timeIntervalSince1970) + String(end.timeIntervalSince1970)
    }
    
    var duration: TimeInterval {
        return end.timeIntervalSince(start)
    }
    
    
    static func getShiftsFromNotification(notification: UNNotification) -> [HWShift] {
       
        var shifts = [HWShift]()
        
        let notificationData = notification.request.content.userInfo
        
        // Try to get the "custom" dictionary from the notification data
        guard let customDict = notificationData["custom"] as? NSDictionary else {
            // If we couldn't get the "custom" dictionary, return an empty array of shifts
            return shifts
        }
        
        // Try to get the "a" dictionary from the "custom" dictionary
        guard let a = customDict["a"] as? NSDictionary else {
            // If we couldn't get the "a" dictionary, return an empty array of shifts
            return shifts
        }
        
        // Try to get the "Shifts" array from the "a" dictionary
        guard let shiftData = a["Shifts"] as? [NSArray] else {
            // If we couldn't get the "Shifts" array, return an empty array of shifts
            return shifts
        }
        
        // Iterate over each shift in the "Shifts" array
        for shiftDatum in shiftData {
            // Try to get the start and end times for the shift
            guard let start = shiftDatum[0] as? TimeInterval,
                  let end = shiftDatum[1] as? TimeInterval else {
                // If we couldn't get the start and end times, skip this shift
                continue
            }
            
            // Create a new shift object with the start and end times, and append it to the shifts array
            shifts.append(HWShift(start: Date(timeIntervalSince1970: start), end: Date(timeIntervalSince1970: end)))
        }
        
        // Return the array of shifts
        return shifts
    }
    
}

struct HWShiftWeek {
    
    var weekOf: Date
    var shifts: [HWShift]
    
}
