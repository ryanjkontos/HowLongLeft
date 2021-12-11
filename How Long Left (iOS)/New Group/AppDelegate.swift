//
//  AppDelegate.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 15/10/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit
import UserNotifications
import CloudKit
import BackgroundTasks
import CoreData

@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
 

    
     let nameConversionsDownloader = NameConversionsDownloader()
    
    let taskID = "com.ryankontos.How-Long-Left.refresh"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        
        
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            self.handleShortcut(shortcutItem)
        }
        
        DispatchQueue.main.async {
        
        WidgetUpdateHandler.shared = WidgetUpdateHandler()
            
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications()
        WatchSessionManager.sharedManager.startSession()
            self.nameConversionsDownloader.downloadNames()
            
        }
        
        if #available(iOS 13.0, *) {
            
            BGTaskScheduler.shared.register(forTaskWithIdentifier: taskID, using: nil) { task in
                self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
            }
            
        } else {
            
            application.setMinimumBackgroundFetchInterval(200)
            
        }
        
        
        if #available(iOS 13.0, *) {
            scheduleAppRefresh()
        }
        
        if #available(iOS 13.0, *) {} else {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
            
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let root = RootViewController()
            let currentViewController = storyboard.instantiateViewController(withIdentifier: "CurrentView") as! CurrentEventsTableViewController
            let upcomingViewController = storyboard.instantiateViewController(withIdentifier: "UpcomingView") as! UpcomingEventsTableViewController
            
            let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsView") as! SettingsTableViewController
                   
            let currentImage = UIImage(named: "CountdownGylph")
            let upcomingImage = UIImage(named: "UpcomingEventsGlyph")
            let settingsImage = UIImage(named: "SettingsGlyph")
            
            let currentNavigationController = UINavigationController(rootViewController: currentViewController)
        
            let upcomingNavigationController = UINavigationController(rootViewController: upcomingViewController)
               
            let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
            
            currentNavigationController.tabBarItem = UITabBarItem(title: "Current", image: currentImage, selectedImage: currentImage)
            
            upcomingNavigationController.tabBarItem = UITabBarItem(title: "Upcoming", image: upcomingImage, selectedImage: upcomingImage)
            
            settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: settingsImage)
                   
            
            window?.tintColor = UIColor.orange
            root.viewControllers = [currentNavigationController, upcomingNavigationController, settingsNavigationController]
            
            
            window?.rootViewController = root
        
            window?.makeKeyAndVisible()
            
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        completionHandler(.newData)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for remote")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("NOT registered for remote, wtf")
    }
    
   func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    runBackgroundTasks()
   
    }
    
    func runBackgroundTasks() {
        
        nameConversionsDownloader.downloadNames()
        
           notoGen.scheduleNotificationsForUpcomingEvents()
           UNUserNotificationCenter.current().removeAllDeliveredNotifications()
           HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
           print("Trig5")
           
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        runBackgroundTasks()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        if #available(iOS 13.0, *) {
            scheduleAppRefresh()
        }
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
     //   HLLDefaults.shared.loadDefaultsFromCloud()
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        DispatchQueue.main.async {
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
        EventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        print("Trig6")
            
        }
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if let id = userActivity.userInfo?["EventID"] as? String {
              
            RootViewController.launchEvent = id
                      
        }
        
        print("Got activity")
        return true
        
    }
    
  
    
    private func handleShortcut(_ item: UIApplicationShortcutItem) {
        
       if let shortcutItem = ApplicationShortcut(rawValue: item.type) {
            
            switch shortcutItem {
            
            case .LaunchCurrentEvents:
                RootViewController.launchPage = .Current
            case .LaunchUpcomingEvents:
                RootViewController.launchPage = .Upcoming
            case .LaunchSettngs:
               RootViewController.launchPage = .Settings
            
        }
            
        }
            
        
    }
    
 
    
    var window: UIWindow?

    let notoGen = EventNotificationScheduler()

}

enum ApplicationShortcut: String {
    
    case LaunchCurrentEvents = "com.ryankontos.howlongleft.currentEventsQuickAction"
    case LaunchUpcomingEvents = "com.ryankontos.howlongleft.upcomingEventsQuickAction"
    case LaunchSettngs = "com.ryankontos.howlongleft.SettingsQuickAction"
    
}


@available(iOS 13.0, *)
extension AppDelegate {
    
    func scheduleAppRefresh() {
        
        BGTaskScheduler.shared.cancelAllTaskRequests()
        let request = BGAppRefreshTaskRequest(identifier: taskID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 300)
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
            
        
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {

        DispatchQueue.global().async {
        
        task.expirationHandler = {
            
        }
        
            let count = HLLDefaults.defaults.integer(forKey: "BGCount")+1
            HLLDefaults.defaults.set(count, forKey: "BGCount")
            
            self.runBackgroundTasks()
            self.scheduleAppRefresh()
            task.setTaskCompleted(success: true)
            
        }
    }

    
}

extension AppDelegate: UNUserNotificationCenterDelegate{

  // This function will be called when the app receive notification
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
    // show the notification alert (banner), and with sound
    completionHandler([.alert, .sound])
  }
    
  // This function will be called right after user tap on the notification
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
    // tell the app that we have finished processing the user’s action / response
    let notificationInfo = response.notification.request.content.userInfo
        
    if let eventID = notificationInfo["eventidentifier"] as? String {
        
        RootViewController.launchEvent = eventID
        
    }
        
    
    
    
    completionHandler()
  }
}
