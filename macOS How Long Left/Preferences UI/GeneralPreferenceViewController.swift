//
//  GeneralPreferenceViewController.swift
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

final class GeneralPreferenceViewController: NSViewController, Preferenceable {
    let toolbarItemTitle = "General"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    
    override var nibName: NSNib.Name? {
        return "GeneralPreferencesView"
    }
    
    @IBOutlet weak var launchAtLoginCheckbox: NSButton!
    @IBOutlet weak var showNextEventCheckbox: NSButton!
    @IBOutlet weak var showUpcomingEventsCheckbox: NSButton!
    @IBOutlet weak var showNextOccurCheckbox: NSButton!
    @IBOutlet weak var showPercentageCheckbox: NSButton!
    @IBOutlet weak var showLocationsCheckbox: NSButton!
    @IBOutlet weak var use24HourTime: NSButton!
    
    @IBAction func launchAtLoginClicked(_ sender: NSButton) {
        
        var state = false
        if sender.state == .on { state = true }
        LaunchAtLogin.isEnabled = state
        
    }
    
    @IBAction func showNextEventClicked(_ sender: NSButton) {
    
        DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.general.showNextEvent = state
            
        }
        
    }
    
    @IBAction func showUpcomingEventsClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.general.showUpcomingEventsSubmenu = state
            
        }
        
    }
    
    @IBAction func showNextOccursClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.general.showNextOccurItems = state
            
        }
        
    }
    
    @IBAction func showPercentageClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.general.showPercentage = state
            
        }
        
    }
    
    @IBAction func use24HourTimeClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.general.use24HourTime = state
            
            HLLDefaults.defaults.set(true, forKey: "changed24HourPref")
            
        }
        
        
    }
    @IBAction func showLocationsClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.general.showLocation = state
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if LaunchAtLogin.isEnabled == true {
            launchAtLoginCheckbox.state = .on
        } else {
            launchAtLoginCheckbox.state = .off
        }
        
        if HLLDefaults.general.showNextEvent == true {
            showNextEventCheckbox.state = .on
        } else {
            showNextEventCheckbox.state = .off
        }
        
        if HLLDefaults.general.showUpcomingEventsSubmenu == true {
            showUpcomingEventsCheckbox.state = .on
        } else {
            showUpcomingEventsCheckbox.state = .off
        }
        
        if HLLDefaults.general.showNextOccurItems == true {
            showNextOccurCheckbox.state = .on
        } else {
            showNextOccurCheckbox.state = .off
        }
        
        if HLLDefaults.general.showPercentage == true {
            showPercentageCheckbox.state = .on
        } else {
            showPercentageCheckbox.state = .off
        }
        
        if HLLDefaults.general.showLocation == true {
            showLocationsCheckbox.state = .on
        } else {
            showLocationsCheckbox.state = .off
        }
        
        if HLLDefaults.general.use24HourTime == true {
            use24HourTime.state = .on
        } else {
            use24HourTime.state = .off
        }
        
        // Setup stuff here
    }
    
}
