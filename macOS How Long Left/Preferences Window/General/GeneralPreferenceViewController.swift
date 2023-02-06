//
//  GeneralPreferenceViewController.swift
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
/*
final class GeneralPreferenceViewController: NSViewController, PreferencePane {
    
    let preferencePaneIdentifier = PreferencePane.Identifier.general
    var preferencePaneTitle: String = "General"

    let toolbarItemIcon = NSImage(named: "gear")!
    
    override var nibName: NSNib.Name? {
        return "GeneralPreferencesView"
    }
    

    
    @IBOutlet weak var launchAtLoginCheckbox: NSButton!
    @IBOutlet weak var showPercentageCheckbox: NSButton!
    @IBOutlet weak var showLocationsCheckbox: NSButton!
    @IBOutlet weak var allDayCheckbox: NSButton!
    @IBOutlet weak var allDayCurrentButton: NSPopUpButton!
    
    var allDayExcludeText = "Require selection to appear in status item"
    var allDayIncludeText = "Automatically include in status item"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.preferredContentSize = CGSize(width: 529, height: 230)
        
  
        allDayCurrentButton.removeAllItems()
        
        allDayCurrentButton.addItems(withTitles: [allDayExcludeText, allDayIncludeText])
        
        if HLLDefaults.general.showAllDayInStatusItem == true {
            
            allDayCurrentButton.selectItem(withTitle: allDayIncludeText)
            
        } else {
            
            allDayCurrentButton.selectItem(withTitle: allDayExcludeText)
            
        }
        
        
        if LaunchAtLogin.isEnabled == true {
            launchAtLoginCheckbox.state = .on
        } else {
            launchAtLoginCheckbox.state = .off
        }
        
        if HLLDefaults.general.showPercentage == true {
            showPercentageCheckbox.state = .on
        } else {
            showPercentageCheckbox.state = .off
        }
        
        
        if HLLDefaults.general.showAllDay == true {
            allDayCheckbox.state = .on
            allDayCurrentButton.isEnabled = true
        } else {
            allDayCheckbox.state = .off
            allDayCurrentButton.isEnabled = false
        }
        
        if HLLDefaults.general.showLocation == true {
            showLocationsCheckbox.state = .on
        } else {
            showLocationsCheckbox.state = .off
        }

        
        // Setup stuff here
    }
    
    @IBAction func launchAtLoginClicked(_ sender: NSButton) {
        
        var state = false
        if sender.state == .on { state = true }
        LaunchAtLogin.isEnabled = state
        
    }
    
    
    @IBAction func showPercentageClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
        
        var state = false
        if sender.state == .on { state = true }
        HLLDefaults.general.showPercentage = state
            
        }
        
    }
    
    @IBAction func iFckingDitchedButtonClicked(_ sender: NSButton) {
        
        if HLLDefaults.statusItem.hideEventsOn == nil {
            HLLDefaults.statusItem.hideEventsOn = Date()
        } else {
            HLLDefaults.statusItem.hideEventsOn = nil
        }
        
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        HLLEventSource.shared.updateEventsAsync()
        
    }
    
    
    @IBAction func showAllDayClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.general.showAllDay = state
            self.allDayCurrentButton.isEnabled = state
            
        HLLDefaultsTransfer.shared.userModifiedPrferences()
            HLLEventSource.shared.updateEventsAsync()
            
        }
        
    }
    
    @IBAction func allDayPopupClicked(_ sender: NSPopUpButton) {
        
        DispatchQueue.main.async {
        
            if sender.selectedItem?.title == self.allDayIncludeText {
            
            HLLDefaults.general.showAllDayInStatusItem = true
            
        } else {
            
            HLLDefaults.general.showAllDayInStatusItem = false
        }
        
        
        HLLDefaultsTransfer.shared.userModifiedPrferences()
         HLLEventSource.shared.updateEventsAsync()
            
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
            
        
        
         HLLEventSource.shared.updateEventsAsync()
            
        }
        
    }
 
    
    override func viewWillAppear() {
        
        PreferencesWindowManager.shared.currentIdentifier = preferencePaneIdentifier
        
    }
    
}
*/
