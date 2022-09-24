//
//  HLLSplitViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 29/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class HLLSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    let tabController = HLLTabViewController()
    let sidebarController = SidebarViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.primaryBackgroundStyle = .sidebar
        
        sidebarController.tabController = tabController
        
        self.delegate = self
        
        self.setViewController(sidebarController, for: .primary)
        self.setViewController(tabController, for: .secondary)
        self.setViewController(tabController, for: .compact)
        
        if UIDevice.current.userInterfaceIdiom != .phone {
        
            self.preferredDisplayMode = .oneBesideSecondary
            self.presentsWithGesture = true
            self.preferredSplitBehavior = .tile
            
          
            #if targetEnvironment(macCatalyst)
            
            self.presentsWithGesture = false
            
            #endif
            
            
        } else {
           
            self.preferredDisplayMode = .secondaryOnly
            
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTabBar()
    }
    

    var systemIsChangingViewSize = false
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        systemIsChangingViewSize = true
        super.viewWillTransition(to: size, with: coordinator)
        systemIsChangingViewSize = false
    }

    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
       // navigationDelegate?.navigationSplitViewController(self, willChangeDisplayMode: displayMode)
        if !systemIsChangingViewSize {
            updateTabBar()
            
        }
    }
    
    func updateTabBar() {
       /* if displayMode == .secondaryOnly && self.displayMode == .oneBesideSecondary {
            DispatchQueue.main.async {
                print("Transition 1")
                self.tabController.tabBar.isHidden = false
            }
        } else if displayMode == .oneBesideSecondary && self.displayMode == .secondaryOnly {
            DispatchQueue.main.async {
                print("Transition 2")
                self.tabController.tabBar.isHidden = true
            }
        } */
    }

    /*
    // MARK: - Navigation

    // In/Users/ryankontos/How Long Left/iOS Widget Intents a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
