//
//  SceneDelegate.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 3/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit
import WidgetKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    private(set) static var shared: SceneDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
      
       
        let root = RootViewController()
        
        Self.shared = self
        window?.tintColor = UIColor.orange
        window?.rootViewController = root
       
        #if !targetEnvironment(macCatalyst)
        
        if let shortcutItem = connectionOptions.shortcutItem {
            
            self.handleShortcut(shortcutItem)
            
        }
        #endif
        
        #if targetEnvironment(macCatalyst)
        if let windowScene = scene as? UIWindowScene {
            if let titlebar = windowScene.titlebar {
                let toolbar = NSToolbar(identifier: "testToolbar")
                
                let rootViewController = window?.rootViewController as? UITabBarController
                rootViewController?.tabBar.isHidden = true
                
                toolbar.delegate = self
                toolbar.allowsUserCustomization = true
                toolbar.centeredItemIdentifier = NSToolbarItem.Identifier(rawValue: "testGroup")
                titlebar.titleVisibility = .hidden
                
                titlebar.toolbar = toolbar
            }
        }
        #endif
        
        
        guard let _ = (scene as? UIWindowScene) else { return }
        self.window?.makeKeyAndVisible()
        
        if let url = connectionOptions.urlContexts.first?.url {
            
            handleLaunchURL(url)
            
        }
        
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
       
     //   WidgetUpdateHandler.shared.updateWidget()
       
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        self.handleShortcut(shortcutItem)
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        
        if let id = userActivity.userInfo?["EventID"] as? String {
              
            RootViewController.launchEvent = id
                      
        }
        
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

    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        
        
        if let url = URLContexts.first?.url {
            
           handleLaunchURL(url)

        }
        
      
    }
    
    
    func handleLaunchURL(_ url: URL) {
       
        HLLDefaults.defaults.set(HLLDefaults.defaults.integer(forKey: "LFW")+1, forKey: "LFW")
        
        if let scheme = url.scheme,
                       scheme.localizedCaseInsensitiveCompare("howlongleft") == .orderedSame, let host = url.host {
                       
                       if host == "current" {
                           RootViewController.launchPage = .Current
                       } else if host == "upcoming" {
                           RootViewController.launchPage = .Upcoming
                       } else if host == "settings" {
                           RootViewController.launchPage = .Settings
                       }
                       
                       if host.contains(text: "EID") {
                           RootViewController.launchEvent = host
                       }
                       
                       if host == "widgetlaunch" {
                           
                           RootViewController.launchToFirstTimelineEventInfoView = true
                           
                       }
            
            DispatchQueue.main.async {
                         
                      guard let window: UIWindow = self.window , var topVC = window.rootViewController?.presentedViewController else {return}
                         while topVC.presentedViewController != nil  {
                             topVC = topVC.presentedViewController!
                         }
                         if topVC.isKind(of: UIAlertController.self) {
                             topVC.dismiss(animated: false, completion: nil)
                         }
                             
                         }
                    
                   }
        
    }
    
    
}

#if targetEnvironment(macCatalyst)
extension SceneDelegate: NSToolbarDelegate {
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if (itemIdentifier == NSToolbarItem.Identifier(rawValue: "testGroup")) {
            let group = NSToolbarItemGroup.init(itemIdentifier: NSToolbarItem.Identifier(rawValue: "testGroup"), titles: ["Current", "Upcoming", "Settings"], selectionMode: .selectOne, labels: ["section1", "section2", "section3"], target: self, action: #selector(toolbarGroupSelectionChanged))
            
            group.setSelected(true, at: 0)
            
            return group
        }
        
        return nil
    }
    
    @objc func toolbarGroupSelectionChanged(sender: NSToolbarItemGroup) {
        print("testGroup selection changed to index: \(sender.selectedIndex)")
        
        let rootViewController = window?.rootViewController as? UITabBarController
        
        if rootViewController?.selectedIndex == sender.selectedIndex {
            
            if let selected = rootViewController?.selectedViewController as? UINavigationController {
                
                selected.popToRootViewController(animated: true)
                
            }
            
        } else {
            rootViewController?.selectedIndex = sender.selectedIndex
        }
        
        
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [NSToolbarItem.Identifier(rawValue: "testGroup")]
    }
    
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return self.toolbarDefaultItemIdentifiers(toolbar)
    }
}
#endif
