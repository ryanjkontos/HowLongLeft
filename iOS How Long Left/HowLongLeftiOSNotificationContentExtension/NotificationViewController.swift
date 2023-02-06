//
//  NotificationViewController.swift
//  HowLongLeftiOSNotificationContentExtension
//
//  Created by Ryan Kontos on 5/12/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import SwiftUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    var hostingView: UIHostingController<HWiOSNotificationView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    func didReceive(_ notification: UNNotification) {
        
        let notificationData = notification.request.content.userInfo
        
        let aps = notificationData["aps"] as? [String: Any]
        let alert = aps?["alert"] as? [String: Any]
        
        let title = alert?["title"] as! String
        
        let body = alert?["body"] as! String
        
        let shifts = HWShift.getShiftsFromNotification(notification: notification)
        
        let notificationView = HWiOSNotificationView(titleText: title, bodyText: body, shifts: shifts)
         hostingView = UIHostingController(rootView: notificationView)
         
        let preferredSize = hostingView.sizeThatFits(in: UIView.layoutFittingExpandedSize)

       // hostingView.sizingOptions = [.preferredContentSize]
        
          // Set the preferredContentSize of the NotificationViewController to the calculated size.
          self.preferredContentSize = preferredSize
        
         self.view.addSubview(hostingView.view)
         hostingView.view.translatesAutoresizingMaskIntoConstraints = false
         
      //  hostingView.view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
         hostingView.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
         hostingView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
         hostingView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         hostingView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }

}

