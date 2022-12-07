//
//  EventSceneDelegate.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 16/8/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
#if canImport(AppKit)
import AppKit
#endif


class EventSceneDelegate: UIResponder, UIWindowSceneDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?

    static let eventSceneTargetContentIdentifier = "howlongleft.eventsceneID"
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let windowScene = scene as? UIWindowScene {
            
            let size = CGSize(width: 1000, height: 640)
            windowScene.sizeRestrictions?.minimumSize = size
            windowScene.sizeRestrictions?.maximumSize = size
            
            
            let window = UIWindow(windowScene: windowScene)
            
            window.tintColor = .systemOrange
            
            window.rootViewController = EventViewController()
           
           
            
            self.window = window
            
            
            
            window.makeKeyAndVisible()
            
            

        }
        
        if let newUserActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            // A user activity was found; configure the session with it.
            if configure(window: window, session: session, with: newUserActivity) {
                scene.userActivity = newUserActivity // Remember this activity for when this app is suspended or quit.
            } else {
                Swift.debug// print("Failed to restore scene from \(newUserActivity)")
            }
            
            // Set the 'can' and 'prefers' predicates for this scene.
            let conditions = scene.activationConditions
            
            // The 'can' or main predicate expresses to the system what kind of content the scene can display.
            let canPredicate = NSPredicate(format: "self == %@", EventSceneDelegate.eventSceneTargetContentIdentifier)
            conditions.canActivateForTargetContentIdentifierPredicate = canPredicate
            
            // The 'prefer' or secondary predicate, expresses to the system that this scene
            // is "especially" interested in a particular kind of content.
            if let eventID = newUserActivity.userInfo!["EventID"] as? String {
                let preferPredicate =
                    NSPredicate(format: "self == %@",
                                "\(EventSceneDelegate.eventSceneTargetContentIdentifier)-\(eventID)")
                conditions.prefersToActivateForTargetContentIdentifierPredicate = preferPredicate
            }
        } else {
            // No user activity to restore here.
        }
        
       
        
        
       
        
    }
    
    func configure(window: UIWindow?, session: UISceneSession, with activity: NSUserActivity) -> Bool {
        // Configure and restore this Inspector window from the input 'activity'.
        activity.delegate = self // So the delegate 'userActivityWillSave' can be called by iOS.

        guard let navController = window!.rootViewController as? UINavigationController else { return false }

        if let viewController = navController.topViewController {
            viewController.userActivity = activity
            
            window?.windowScene?.title = "Event"
            
            // Mark the session with a specific photo, so you can check for it later if you want to reactivate this scene.
            session.userInfo =
                ["EventID": activity.userInfo!["EventID"] as Any]
        }
        
        // Set the scene title; this will be seen in the app switcher as the title of the scene, or for Mac Catalyst the window title.
        if activity.userInfo != nil {
           // window?.windowScene?.title = activity.userInfo?[UserActivity.GalleryOpenDetailPhotoTitleKey] as? String
        }
        
        return true
    }
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }
   
    
    class func openEventSceneSessionForEvent(_ event: HLLEvent, requestingScene: UIWindowScene, errorHandler: ((Error) -> Void)? = nil) {
        let options = UIWindowScene.ActivationRequestOptions()
        
        
        options.preferredPresentationStyle = .prominent
        options.requestingScene = requestingScene // The scene object that requested the activation of a different scene.
        
        // Present this scene as a secondary window separate from the main window.
        //
        // Look for an already open window scene session that matches the photo.
        if let foundSceneSession = EventSceneDelegate.activeEventSceneSessionForEvent(event) {
            // Inspector scene session already open, so activate it.
            UIApplication.shared.requestSceneSessionActivation(foundSceneSession, // Activate the found scene session.
                                                               userActivity: nil, // No need to pass activity for an already open session.
                                                               options: options,
                                                               errorHandler: errorHandler)
        } else {
            // No Inspector scene session found, so create a new one.
            let userActivity = event.userActivity
    
            UIApplication.shared.requestSceneSessionActivation(nil, // Pass nil means make a new one.
                                                               userActivity: userActivity,
                                                               options: options,
                                                               errorHandler: errorHandler)
        }
    }
    
    class func activeEventSceneSessionForEvent(_ event: HLLEvent) -> UISceneSession? {
        var foundSceneSession: UISceneSession!

        for session in UIApplication.shared.openSessions
        where session.configuration.delegateClass == EventSceneDelegate.self {
            if let userInfo = session.userInfo {
                if userInfo["EventID"] as? String == event.persistentIdentifier {
                    // An open session was found that matches the photo to activate.
                    // print("Found existing")
                    foundSceneSession = session
                    break
                }
            }
        }
        return foundSceneSession
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == UserActivity.viewEventKey else { return }
        
        // Pass the user activity product over to this view controller.
        if let navController = window?.rootViewController as? UINavigationController {
            if let secondViewController = navController.topViewController as? EventViewController {
                secondViewController.userActivity = userActivity
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
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


}

extension EventSceneDelegate: NSUserActivityDelegate {
    // Notified that the user activity will be saved to be continued or persisted.
    func userActivityWillSave(_ userActivity: NSUserActivity) {
       //..
    }
    
}
/*
extension UIWindow {
    var nsWindow: NSObject? {
        var nsWindow = Dynamic.NSApplication.sharedApplication.delegate.hostWindowForUIWindow(self)
        if #available(macOS 11, *) {
            nsWindow = nsWindow.attachedWindow
        }
        return nsWindow.asObject
    }
}
*/
