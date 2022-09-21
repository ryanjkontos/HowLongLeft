//
//  CalendarPreferenceViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa
import Preferences
import LaunchAtLogin
import EventKit


final class CalendarPreferenceViewControllerNoAccess: NSViewController, Preferenceable {
    let toolbarItemTitle = "Calendar"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    
    
    override var nibName: NSNib.Name? {
        return "CalendarPreferencesViewNoAccess"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
