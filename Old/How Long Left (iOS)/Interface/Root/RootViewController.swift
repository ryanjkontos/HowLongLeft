//
//  RootViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 4/4/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit
import StoreKit
import EventKit

class RootViewController: UITabBarController, UITabBarControllerDelegate, CalendarAccessStateDelegate, EventPoolUpdateObserver {
    
    
    var currentVC: UINavigationController!
    var upcomingVC: UINavigationController!
    var settingsVC: UINavigationController!
    
    var navBar: UINavigationBar?
    
    static var shared: RootViewController?
    static var selectedController: UIViewController?
    
    static var hasFadedIn = false
    
    static var launchPage: TabBarPage? {
        
        didSet {
            
          if let launch = RootViewController.launchPage {
            
            RootViewController.shared?.setSelectedPage(to: launch)
            (RootViewController.shared?.selectedViewController as? UINavigationController)?.popToRootViewController(animated: false)
                
            }
            
            
        }
        
    }
    
    static var launchEvent: String? {
        
        didSet {
            
            if RootViewController.launchEvent != nil {
                RootViewController.shared?.checkLaunchEvent()
            }
            
            
            
        }
        
    }
    
    static var launchToFirstTimelineEventInfoView = false {
        
        didSet {
            
            if RootViewController.launchToFirstTimelineEventInfoView {
                RootViewController.shared?.presentFirstTimelineEventInfoView()
            }
            
        }
        
    }
    
    var prev: UIViewController?
    
    var gotComplicationPrice = false
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if self.selectedViewController == viewController, viewController == prev {
            
            
            if let nav = viewController as? UINavigationController {
                
                if let vc = nav.topViewController as? ScrollUpDelegate {
                
                vc.scrollUp()
                    
                }
                
                
            }
            
        }
        
        prev = viewController
        
    }

    var currentPage: TabBarPage {
        
        get {
            
            return TabBarPage(rawValue: self.selectedIndex)!
            
        }
        
    }
    
    var dataSource: HLLEventSource?

    static var hasLaunched = false
    let schoolAnalyser = SchoolAnalyser()
    
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        self.navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        self.view.addSubview(self.navBar!)
    }
    
    override func viewDidLoad() {
  
        print("Root view did load")
        
        HLLEventSource.shared.addEventPoolObserver(self, immediatelyNotify: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let current = storyboard.instantiateViewController(withIdentifier: "CurrentView") as! CurrentEventsTableViewController
        let upcoming = storyboard.instantiateViewController(withIdentifier: "UpcomingView") as! UpcomingEventsTableViewController
        let settings = storyboard.instantiateViewController(withIdentifier: "SettingsView") as! SettingsTableViewController
              
               
        self.currentVC = UINavigationController(rootViewController: current)
        self.upcomingVC = UINavigationController(rootViewController: upcoming)
        self.settingsVC = UINavigationController(rootViewController: settings)
               
        let currentImage = UIImage(named: "CountdownGylph")
        let upcomingImage = UIImage(named: "UpcomingEventsGlyph")
        let settingsImage = UIImage(named: "SettingsGlyph")
        
        self.currentVC.tabBarItem = UITabBarItem(title: "Current", image: currentImage, selectedImage: currentImage)
        self.upcomingVC.tabBarItem = UITabBarItem(title: "Upcoming", image: upcomingImage, selectedImage: upcomingImage)
        self.settingsVC.tabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: settingsImage)
                      
        
       
        IAPHandler.shared.fetchAvailableProducts()
        let array: [HLLEventInfoItemType] = [HLLEventInfoItemType.calendar, HLLEventInfoItemType.completion, HLLEventInfoItemType.countdown]
        let arrayTwo: [HLLEventInfoItemType] = [HLLEventInfoItemType.start, HLLEventInfoItemType.end]
        
        let multi = [array, arrayTwo]
        
        HLLDefaults.general.eventInfoOrdering = multi
        
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemGroupedBackground
        } else {
            view.backgroundColor = UIColor.groupTableViewBackground
        }
        
        self.prev = self.selectedViewController
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showIAPSuggestion), name: Notification.Name("gotComplicationPrice"), object: nil)
        
        self.delegate = self
        
        super.viewDidLoad()
        RootViewController.shared = self
        
       
        
        DispatchQueue.main.async {
            self.checkLaunchEvent()
            
            
        }
        
        presentFirstTimelineEventInfoView()
        
      
        print("IDB: Root view loaded")
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
        checkLaunchEvent()
        //HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
        //print("Trig7")
    }
    
    @objc func showIAPSuggestion() {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                
                if HLLEventSource.shared.neverUpdatedEventPool == false {
                
                    if WatchSessionManager.sharedManager.userHasAppleWatch() {
                
                if IAPHandler.shared.hasPurchasedComplication() == false, HLLDefaults.defaults.bool(forKey: "ShownIAPSuggestion") == false, IAPHandler.complicationPriceString != nil {
                    
                    if self.gotComplicationPrice == false {
                        
                        HLLDefaults.defaults.set(true, forKey: "ShownIAPSuggestion")
                    
                        self.gotComplicationPrice = true
                        
                    let vc = BackgroundFunctions.shared.getPurchaseComplicationViewController()
                    
                    self.present(vc, animated: true, completion: nil)
                        
                    }
                }
                    
                    if SchoolAnalyser.privSchoolMode == .Magdalene {
                        
                        HLLDefaults.defaults.set(true, forKey: "ShownIAPSuggestion")
                        
                    }
                    
                }
                    
                }
                
            })
        
        
                
        
        
    }
    
    @objc func updateTheme() {
    
      /*  self.navigationController?.navigationBar.barStyle = AppTheme.currentTheme.barStyle
        self.tabBar.barStyle = AppTheme.currentTheme.barStyle
        self.navigationController?.navigationBar.isTranslucent = AppTheme.currentTheme.translucentBars
        self.tabBar.isTranslucent = AppTheme.currentTheme.translucentBars
        self.tabBar.barStyle = AppTheme.currentTheme.barStyle */
        
    }
    
    func setSelectedPage(to page: TabBarPage) {
        
        self.selectedIndex = page.rawValue
        
        
        
    }
    
    func calendarAccessDenied() {
        let alertController = UIAlertController(title: "How Long Left does not have permission to access your calendar", message: "You can grant it in Settings.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction) in
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    })
                }
            }
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.view.tintColor = UIColor.HLLOrange
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    func showComplicationPurchasedFailedAlert() {
        
        var errorReasonString: String? = "Please try again"
        
        if let error = IAPHandler.recentTransaction?.error as? SKError {
            
            switch error.code {
                
            case .unknown:
                break
            case .clientInvalid:
                break
            case .paymentCancelled:
                errorReasonString = nil
            case .paymentInvalid:
                errorReasonString = "Invalid payment"
            case .paymentNotAllowed:
                errorReasonString = "Invalid payment"
            case .storeProductNotAvailable:
                errorReasonString = "The product is not avaliable"
            case .cloudServicePermissionDenied:
                errorReasonString = "Could could connect to the App Store."
            case .cloudServiceNetworkConnectionFailed:
                errorReasonString = "Could could connect to the App Store."
            case .cloudServiceRevoked:
                errorReasonString = "Could could connect to the App Store."
            case .privacyAcknowledgementRequired:
                errorReasonString = nil
            case .unauthorizedRequestData:
                break
            case .invalidOfferIdentifier:
                break
            case .invalidSignature:
                break
            case .missingOfferParams:
                break
            case .invalidOfferPrice:
                break
            @unknown default:
                break
            }
        }
        
        if let reason = errorReasonString {
        
            let alertController = UIAlertController(title: "Purchase Failed", message: reason, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action1)
        alertController.view.tintColor = UIColor.HLLOrange
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
            
            }
        }
        
    }
    
    func showComplicationPurchasedAlert(purchasedNow: Bool, restored: Bool = false) {
        
        var message = "You may need to launch How Long Left on your watch to trigger changes."
        var titleText = "You've purchased the Apple Watch Complication"
        
        if purchasedNow {
            
            titleText = "Purchase Successful!"
            
        } else {
            
            if SchoolAnalyser.privSchoolMode == .Magdalene {
                
                titleText = "Apple Watch Complication is enabled"
                message = "As a Magdalene user, you have access to the complication for free."
                
            }
            
        }
        
        if restored == true {
            
            titleText = "Restore Successful!"
            
        }
        
        let alertController = UIAlertController(title: titleText, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action1)
        alertController.view.tintColor = UIColor.HLLOrange
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }

   
    
    func presentFirstTimelineEventInfoView() {
        
        if RootViewController.launchToFirstTimelineEventInfoView {
            HLLDefaults.defaults.set(true, forKey: "LTT")
        } else {
            HLLDefaults.defaults.set(false, forKey: "LTT")
            return
        }
        
            DispatchQueue.main.async {
            
            if HLLEventSource.shared.neverUpdatedEventPool {
                HLLEventSource.shared.updateEventPool()
            }
            
            if let event = HLLEventSource.shared.getTimeline().first {
                
                
                switch event.completionStatus {
                    
                case .Upcoming:
                    self.setSelectedPage(to: .Upcoming)
                case .Current:
                    self.setSelectedPage(to: .Current)
                case .Done:
                    self.setSelectedPage(to: .Current)
                }
                
                  
                
                if let selectedController = self.selectedViewController as? UINavigationController {
                        
                    print("NotoLaunch 1")
                        
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            
                        var matchingEventController: UIViewController?
                            
                        for view in selectedController.viewControllers {
                                
                                if let eventInfoView = view as? EventInfoViewController {
                                    
                                    if eventInfoView.event == event {
                                        
                                        matchingEventController = eventInfoView
                     
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            if let safeController = matchingEventController {
                                
                                selectedController.popToViewController(safeController, animated: true)
                                
                            } else {
                                
                                let newView = EventInfoViewGenerator.shared.generateEventInfoView(for: event)
                                selectedController.popToRootViewController(animated: true)
                                selectedController.pushViewController(newView, animated: true)
                                
                            }
                            
                            
                        })
                        
                    }
                    
                    
                
                
            }
            
            RootViewController.launchEvent = nil
            
        }

        
    }
    
    func checkLaunchEvent() {
        
        DispatchQueue.main.async {
        
        if HLLEventSource.shared.neverUpdatedEventPool {
            HLLEventSource.shared.updateEventPool()
        }
        
        if let id = RootViewController.launchEvent, let event = HLLEventSource.shared.findEventWithIdentifier(id: id) {
            
            print("NotoLaunch Match")
            
            var isValid = false
            
            switch event.completionStatus {
                
            case .Upcoming:
                self.setSelectedPage(to: .Upcoming)
                isValid = true
            case .Current:
                self.setSelectedPage(to: .Current)
                isValid = true
            case .Done:
                isValid = true
                self.setSelectedPage(to: .Current)
            }
            
            if isValid {
                
                print("NotoLaunch Is Valid")
                
                print("NotoLaunch Selected DBD: \(self.selectedViewController.debugDescription)")
                
                if let selectedController = self.selectedViewController as? UINavigationController {
                    
                    print("NotoLaunch 1")
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                        
                        var matchingEventController: UIViewController?
                        
                        for view in selectedController.viewControllers {
                            
                            if let eventInfoView = view as? EventInfoViewController {
                                
                                if eventInfoView.event == event {
                                    
                                    matchingEventController = eventInfoView
                                    print("NotoLaunch 2")
                                    
                                }
                                
                            }
                            
                        }
                        
                        if let safeController = matchingEventController {
                            
                            selectedController.popToViewController(safeController, animated: true)
                            
                        } else {
                            
                            print("NotoLaunch 3")
                            let newView = EventInfoViewGenerator.shared.generateEventInfoView(for: event)
                            selectedController.popToRootViewController(animated: true)
                            selectedController.pushViewController(newView, animated: true)
                            
                        }
                        
                        
                    })
                    
                }
                
                
            }
            
        }
        
        RootViewController.launchEvent = nil
        
    }
        
    }
    
    func doNotificationOnboarding() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if HLLDefaults.notifications.doneNotificationOnboarding == false, HLLDefaults.notifications.presentedNotificationOnboarding == false {
                
                HLLDefaults.notifications.presentedNotificationOnboarding = true
                
                let alertController = UIAlertController(title: "Event Notifications", message: "Would you like to enable and configure notifications for your events?", preferredStyle: .alert)
                
                let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    
                    HLLDefaults.notifications.enabled = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                        
                        self.setSelectedPage(to: .Settings)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        
                        if let selectedController = self.selectedViewController as? UINavigationController {
                            
                            HLLDefaults.notifications.enabled = true
                            
                            var tableViewType = UITableView.Style.grouped
                            if #available(iOS 13.0, *) {
                                tableViewType = .insetGrouped
                            }
                            
                            
                            let notificationsViewController = NotificationConfigurationTableViewController(style: tableViewType)
                            selectedController.pushViewController(notificationsViewController, animated: true)
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                
                                
                                HLLDefaults.notifications.doneNotificationOnboarding = true
                                EventNotificationScheduler.shared.getAccess()
                                
                            })
                            
                        }

                        }
                        
                    }
                    
                    
                }
                
                let action2 = UIAlertAction(title: "Not Now", style: .cancel) { (action:UIAlertAction) in
                    HLLDefaults.notifications.doneNotificationOnboarding = true
                    
                }
                
                alertController.addAction(action1)
                alertController.addAction(action2)
                alertController.view.tintColor = UIColor.HLLOrange
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            
        }
        
        
        
    }
    
    func eventPoolUpdated() {
 
        print("Root got event pool updated noto")
        
        DispatchQueue.main.async {
        
            self.navBar?.removeFromSuperview()
            self.viewControllers = [self.currentVC, self.upcomingVC, self.settingsVC]
        
            
            let currentIsEmpty = HLLEventSource.shared.getCurrentEvents(includeHidden: true).filter({$0.isHidden == false}).isEmpty
                   let upcomingIsEmpty = HLLEventSource.shared.getUpcomingEventsFromNextDayWithEvents().isEmpty
                   
                   if RootViewController.hasLaunched == false {
                       
                       RootViewController.hasLaunched = true
                       
                   if let launchPage = RootViewController.launchPage {
                       
                    self.setSelectedPage(to: launchPage)
                       //(RootViewController.shared?.selectedViewController as? UINavigationController)?.popToRootViewController(animated: false)
                       
                       
                   } else if currentIsEmpty, upcomingIsEmpty == false {
                       
                    self.setSelectedPage(to: .Upcoming)
                       
                   } else {
                       
                    self.setSelectedPage(to: .Current)
                       
                   }
                       
                   }

        
        if HLLEventSource.shared.neverUpdatedEventPool == false {
        self.doNotificationOnboarding()
        }
        
        
            
            self.checkLaunchEvent()
            
        }
            
    }
       

}

enum TabBarPage: Int {
    
    case Current = 0
    case Upcoming = 1
    case Settings = 2
    
}

protocol ScrollUpDelegate {
    func scrollUp()
}
