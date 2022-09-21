//
//  AppDelegate.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 27/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

   // static var plugin: HLLAppKitBundleProtocol?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        #if targetEnvironment(macCatalyst)
        
       
        
        #endif
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        var configurationName: String!

        switch options.userActivities.first?.activityType {
        case UserActivity.viewEventKey:
            configurationName = "Event Configuration"
        default:
            configurationName = "Default Configuration"
        }
        
        return UISceneConfiguration(name: configurationName, sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /*      private func loadPlugin() {
        /// 1. Form the plugin's bundle URL
        let bundleFileName = "HLLAppKitBundle.bundle"
        guard let bundleURL = Bundle.main.builtInPlugInsURL?
                                    .appendingPathComponent(bundleFileName) else { return }

        /// 2. Create a bundle instance with the plugin URL
        let bundle = Bundle(url: bundleURL)!

        /// 3. Load the bundle and our plugin class
        let className = "HLLAppKitBundle.HLLMacPluginClass"
        let pluginClass = bundle.principalClass as! HLLAppKitBundleProtocol.Type

        /// 4. Create an instance of the plugin class
              AppDelegate.plugin = pluginClass.init()
        
    }
*/

}

