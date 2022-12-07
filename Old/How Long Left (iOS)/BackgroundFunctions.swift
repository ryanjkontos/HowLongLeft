//
//  BackgroundFunctions.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 1/4/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

#if canImport(Intents)
import Intents
import IntentsUI
#endif
import SystemConfiguration
import Reachability

class BackgroundFunctions {
    
  
    static let shared = BackgroundFunctions()
    static var isReachable = false
    private let notoScheduler = EventNotificationScheduler()

    var rb: Reachability?
    
    init() {
        
        do
        {
            self.rb = try Reachability()
        }
        catch let error as NSError
        {
            // print(error.localizedDescription)
        }
        
        DispatchQueue.global(qos: .default).async {
        
        VoiceShortcutStatusChecker.shared.check()

        
            self.rb?.whenReachable = { reachability in
            
            BackgroundFunctions.isReachable = true
            if IAPHandler.complicationPriceString == nil {
                
                IAPHandler.shared.fetchAvailableProducts()
                
            }
            
            if reachability.connection == .wifi {
                // print("Reachable via WiFi")
            } else {
                // print("Reachable via Cellular")
            }
        }
            self.rb?.whenUnreachable = { _ in
            // print("Not reachable")
            
            BackgroundFunctions.isReachable = false
            
        }
        
        do {
            try self.rb?.startNotifier()
        } catch {
            // print("Unable to start notifier")
        }
        
        self.run()
    }

    }
    
    func run() {
        
        DispatchQueue.main.async {
        
            IAPHandler.shared.fetchAvailableProducts()
            
        VoiceShortcutStatusChecker.shared.check()
        self.donateInteraction()

            
        // print("Start2")
        
        
        self.notoScheduler.getAccess()
        self.notoScheduler.scheduleNotificationsForUpcomingEvents()
        
        
        }
        
    }
    
   private func donateInteraction() {
        if #available(iOS 12.0, *) {
            let intent = HowLongLeftIntent()
            
            intent.suggestedInvocationPhrase = "How long left"
            
            let interaction = INInteraction(intent: intent, response: nil)
            
            interaction.donate { (error) in
                if error != nil {
                    if let error = error as NSError? {
                        // print("Failed to donate because \(error)")
                    } else {
                        // print("Successfully donated")
                    }
                }
            }
        }
        
    }
    
    func getPurchaseComplicationViewController(with tableView: UITableViewController? = nil, preview: Bool = false) -> UIViewController {
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewController(withIdentifier: "PurchaseVC") as! IAPRootView
            viewController.delegateTable = tableView
            viewController.configureForPreview = preview
            return viewController
    }
    
    
    
}

