//
//  AppSheetOverlayManager.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 16/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import UIKit
import SwiftUI

class AppSheetOverlayManager {
    

    
    func getSheetViewControllerIfNeeded() -> UIViewController? {
        
        if HLLDefaults.defaults.bool(forKey: "HLLWelcome_Completed") {
            return nil
        }
        
        return UIHostingController(rootView: NavigationView { WelcomeView() }.navigationViewStyle(.stack)) 
        
        
    }
    
}
