//
//  HLLWatchNotificationController.swift
//  How Long Left
//
//  Created by Ryan Kontos on 4/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import WatchKit
import SwiftUI
import UserNotifications

class HWShiftsNotificationController: WKUserNotificationHostingController<HWShiftsNotificationView> {
    
    
    var title: String?
    //var message: String?
    
    var shifts = [HWShift]()
    
    
    
    
    
    override var body: HWShiftsNotificationView {
        HWShiftsNotificationView(titleText: title!, shifts: shifts)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
    }
    
    override class var wantsSashBlur: Bool {
        return true
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func didReceive(_ notification: UNNotification) {
   
        shifts = HWShift.getShiftsFromNotification(notification: notification)
        
        
        let notificationData = notification.request.content.userInfo
        
        let aps = notificationData["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        title = alert?["title"] as? String
        
       
    }
}
