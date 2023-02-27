//
//  SceneDelegate.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 21/11/21.
//  Copyright © 2021 Ryan Kontos. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private var hllRoot = HLLRootViewController(style: .doubleColumn)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.tintColor = .systemOrange
            window.rootViewController = hllRoot
            window.makeKeyAndVisible()
            self.window = window
        }
        
        Task {
            let _ = HLLTimelineGenerator(type: .complication).generateHLLTimeline(forState: .normal)
        }
       
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
        Task.detached {
            await Store.shared.refreshPurchasedProducts()
        }
        
        
        
        HLLEventSource.shared.shiftLoader.load()

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
       // HLLBackgroundTasks.shared.scheduleAppRefresh()
        
        Task {
            await Store.shared.refreshPurchasedProducts()
            HLLEventSource.shared.shiftLoader.load()
        }
        
        
        
        DispatchQueue.main.async {
            WidgetUpdateHandler.shared.updateConfigDict()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            
            NicknameManager.shared.loadNicknames()
            
        })
        
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
        let operation = WidgetUpdateOperation()
        operation.start()
        
        HLLBackgroundTasks.shared.scheduleAppRefresh()
        
        NicknameManager.shared.loadNicknames()
        
       
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        if let url = URLContexts.first?.url {
           handleLaunchURL(url)
        }
        
        
      
    }

    func handleLaunchURL(_ url: URL) {
       
        
        if let scheme = url.scheme,
                       scheme.localizedCaseInsensitiveCompare("howlongleft") == .orderedSame, let host = url.host {
            
            if let event = HLLEventSource.shared.events.first(where: { $0.persistentIdentifier == host }) {
                // print("Got event from host")
            }
            
        }
        
    }
    
}

