//
//  CalendarPreferenceViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import Preferences
import LaunchAtLogin
import EventKit


final class CalendarPreferenceViewControllerNoAccess: NSViewController, PreferencePane {
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.calendarsNoAccess
    var preferencePaneTitle: String = "Calendars"
    
    let toolbarItemIcon = PreferencesGlobals.calendarImage
    
    
    override var nibName: NSNib.Name? {
        return "CalendarPreferencesViewNoAccess"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 529, height: 142)
        
        // Setup stuff here
    }
    
    @IBAction func openSystemPreferencesClicked(_ sender: Any) {
        
        
        DispatchQueue.main.async {
        
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Calendars"),
            
            NSWorkspace.shared.open(url) {
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NSWorkspace.shared.launchApplication("System Preferences")
        }
        
    }
    
    }
}
