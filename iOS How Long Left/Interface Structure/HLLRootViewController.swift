//
//  HLLRootViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 29/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
import SwiftUI

class HLLRootViewController: UISplitViewController, UISplitViewControllerDelegate {

    let appSheetManager = AppSheetOverlayManager()
    
    let tabController = HLLTabViewController()
    let sidebarController = SidebarViewController()
    
    var systemIsChangingViewSize = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.primaryBackgroundStyle = .sidebar
        
        InfoAlertBox.shared = InfoAlertBox(tabController: tabController)
        
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
            self.displayModeButtonVisibility = .never
            self.presentsWithGesture = false
            self.preferredDisplayMode = .secondaryOnly
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
         //   self.showOverlay()
            
        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        systemIsChangingViewSize = true
        super.viewWillTransition(to: size, with: coordinator)
        systemIsChangingViewSize = false
    }

    
    func showOverlay() {
        
        if let sheetController = appSheetManager.getSheetViewControllerIfNeeded() {
            self.present(sheetController, animated: true)
        }
       
       
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
