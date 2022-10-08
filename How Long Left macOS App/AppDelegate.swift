//
//  AppDelegate.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 18/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa
import Preferences
import CloudKit
import UserNotifications

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
    
    var utilityRunLoopManager: UtilityRunLoopManager!
   
    
    
    func applicationWillFinishLaunching(_ notification: Notification) {
 
        ProStatusManager.shared = ProStatusManager()
        HLLStoredEventManager.shared.loadStoredEventsFromDatabase()
        HLLEventSource.shared.updateEventPool()
        //WidgetUpdateHandler.shared = WidgetUpdateHandler()
        
        DispatchQueue.main.async {
           
//            HLLDataModel.persistentContainer.viewContext.stalenessInterval = 0.0
            

            
        
        let start = Date()
        
         
        
        HLLStatusItemManager.shared = HLLStatusItemManager()
        
        print("Initialised Status Item Manager in \(Date().timeIntervalSince(start)) seconds.")
            
        }
        
        HLLEventSource.shared.asyncUpdateEventPool()
        
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        
      
        
        DispatchQueue.main.async {
            
          
            
            NSUserNotificationCenter.default.delegate = self
                   if #available(OSX 10.14, *) {
                       UNUserNotificationCenter.current().delegate = self
                   }

            self.utilityRunLoopManager = UtilityRunLoopManager()
            
            
            ProPurchaseHandler.shared.fetchAvailableProducts()
            MacEventNotificationScheduler.shared = MacEventNotificationScheduler()
              HotKeyHandler.shared = HotKeyHandler()

              LaunchFunctions.shared.runLaunchFunctions()
              
              
              
            
        }
     
 
       
        
        
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        
        return true
    }
    

    
    
    func application(_ application: NSApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        guard let url = URL(string: "https://onesignal.com/api/v1/players"),
            let payload = """
            {\"app_id\" : \"4cee5584-c50d-406f-9ddf-483da36934d2\",
            \"identifier\":\"\(token)\",
            \"device_type\":9}
            """
            .data(using: .utf8) else
            
        {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data"); return }

            if let str = String(data: data, encoding: .utf8) {
                print(str)
            }
        }.resume()
        
    }
    
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        
        
        print("Got remote")
        
      
    }
    
    
    func applicationWillTerminate(_ notification: Notification) {
        
        if #available(macOS 10.14, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            
            for noto in NSUserNotificationCenter.default.scheduledNotifications {
                NSUserNotificationCenter.default.removeScheduledNotification(noto)
            }
            
        }
        
       
        
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter,
                                didActivate notification: NSUserNotification) {
        if notification.identifier == "Update" {
            if let url = URL(string: "macappstore://showUpdatesPage"), NSWorkspace.shared.open(url) {
                print("default browser was successfully opened")
            }
            print("Update clicked")
        } else if notification.identifier == "Cal" {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"),
                
                NSWorkspace.shared.open(url) {
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                NSWorkspace.shared.launchApplication("System Preferences")
            }
        }    }

    
    func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
        
        DispatchQueue.main.async {
            
            if let id = userActivity.userInfo?["EventID"] as? String {
                
                print("Launching with \(id)")
                
                if let event = HLLEventSource.shared.findEventWithAppIdentifier(id: id) {
                    
                    EventUIWindowsManager.shared.launchWindowFor(event: event)
                    
                }
                
            }
            
            
            
        }
        
        
        return true
        
    }
    

    
    
}

@available(OSX 10.14, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
      // show the notification alert (banner), and with sound
      completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let notificationInfo = response.notification.request.content.userInfo
               
           if let type = notificationInfo["Type"] as? String {
               
            if type == "Cal" {
            
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"),
                
                NSWorkspace.shared.open(url) {
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                NSWorkspace.shared.launchApplication("System Preferences")
            }

            }
               
           }
    
           completionHandler()
         }

    
}

