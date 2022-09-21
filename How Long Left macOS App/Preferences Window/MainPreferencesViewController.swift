//
//  MainPreferencesViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 18/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa
import Preferences
import LaunchAtLogin
import EventKit

final class MainPreferenceViewController: NSViewController, PreferencePane {
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    var preferencePaneTitle: String = "General"

    let toolbarItemIcon = NSImage(named: "gear")!
    
    override var nibName: NSNib.Name? {
        return "MainPreferencesView"
    }
    
   
    
    var allDayExcludeText = "Require selection to appear in status item"
    var allDayIncludeText = "Automatically include in status item"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 529, height: 230)
        
  
    }
    
   
 
    
    override func viewWillAppear() {
        
        PreferencesWindowManager.shared.currentIdentifier = preferencePaneIdentifier
        
    }
    
}
