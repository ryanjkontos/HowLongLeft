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

final class GeneralPreferenceViewController: NSViewController, PreferencePane {

    let preferencePaneIdentifier = Preferences.PaneIdentifier.general
    var preferencePaneTitle: String = "General"
    
    let toolbarItemIcon = PreferencesGlobals.generalImage
    
    @IBOutlet weak var listUpcomingButton: NSButton!
    @IBOutlet weak var upcomingTypePopup: NSPopUpButton!
    @IBOutlet weak var showUpcomingWeekButton: NSButton!
    @IBOutlet weak var showNextOccurencesButton: NSButton!
    @IBOutlet weak var groupFollowingOccurencesButton: NSButton!
    @IBOutlet weak var groupFollowingOccurencesDescription: NSTextField!
    
    var listUpcomingOptionTopLevel = "In the top level menu"
    var listUpcomingOptionDedicated = "In a dedicated submenu"
    
    var allDayExcludeText = "Require selection to appear in status item"
    var allDayIncludeText = "Automatically include in status item"
    
    @IBOutlet weak var launchAtLoginButton: NSButton!
    
    
    @IBOutlet weak var showPercentageButton: NSButton!
    @IBOutlet weak var showLocationsButton: NSButton!
    @IBOutlet weak var showAllDayButton: NSButton!

    
    
    override var nibName: NSNib.Name? {
        return "MenuPreferencesView"
    }
    
    override func viewWillAppear() {
        
        PreferencesWindowManager.shared.currentIdentifier = preferencePaneIdentifier
        
    }
    
    override func viewDidLoad() {
        
        self.preferredContentSize = CGSize(width: 515, height: 403)
        
        // Menu
        
        if HLLDefaults.menu.listUpcoming == true {
            listUpcomingButton.state = .on
            upcomingTypePopup.isEnabled = true
        } else {
            listUpcomingButton.state = .off
            upcomingTypePopup.isEnabled = false
        }
        
        upcomingTypePopup.removeAllItems()
        
        upcomingTypePopup.addItems(withTitles: [listUpcomingOptionDedicated, listUpcomingOptionTopLevel])
        
        if HLLDefaults.menu.topLevelUpcoming == true {
            upcomingTypePopup.selectItem(withTitle: listUpcomingOptionTopLevel)
        } else {
            upcomingTypePopup.selectItem(withTitle: listUpcomingOptionDedicated)
        }
        
        if HLLDefaults.general.showUpcomingWeekMenu == true {
            showUpcomingWeekButton.state = .on
        } else {
            showUpcomingWeekButton.state = .off
        }
        
        if HLLDefaults.general.useNextOccurList == true {
            groupFollowingOccurencesButton.state = .on
        } else {
            groupFollowingOccurencesButton.state = .off
        }

        if HLLDefaults.general.showNextOccurItems == true {
            showNextOccurencesButton.state = .on
            groupFollowingOccurencesButton.isEnabled = true
            groupFollowingOccurencesDescription.isEnabled = true
        } else {
            showNextOccurencesButton.state = .off
            groupFollowingOccurencesButton.isEnabled = false
            groupFollowingOccurencesDescription.isEnabled = false
        }

        // General
        
 
        
        if HLLDefaults.general.showPercentage == true {
            showPercentageButton.state = .on
        } else {
            showPercentageButton.state = .off
        }
        
    
        
        if HLLDefaults.general.showLocation == true {
            showLocationsButton.state = .on
        } else {
            showLocationsButton.state = .off
        }
        
        if LaunchAtLogin.isEnabled == true {
                  launchAtLoginButton.state = .on
              } else {
                  launchAtLoginButton.state = .off
              }
        
        
        updateGroupTextState()
    }
    
    
    @IBAction func launchAtLoginClicked(_ sender: NSButton) {
        
        var state = false
        if sender.state == .on { state = true }
        LaunchAtLogin.isEnabled = state
        
    }
    
    
    @IBAction func listUpcomingClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.menu.listUpcoming = state
            self.upcomingTypePopup.isEnabled = state
            
        }
        
    }
    
    
    
    
    @IBAction func listUpcomingPopupClicked(_ sender: NSPopUpButton) {
        
        if sender.selectedItem?.title == listUpcomingOptionTopLevel {
            
            HLLDefaults.menu.topLevelUpcoming = true
            
        } else {
            
            HLLDefaults.menu.topLevelUpcoming = false
        }
        
    }
    

    
    @IBAction func groupNextOccurClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.general.useNextOccurList = state
            self.updateGroupTextState()
        }
    }
    
    
    @IBAction func showUpcomingWeekClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.general.showUpcomingWeekMenu = state
            
        }
    }
    
    @IBAction func showNextOccurencesClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            
            var state = false
            if sender.state == .on { state = true }
            HLLDefaults.general.showNextOccurItems = state
            
            self.groupFollowingOccurencesButton.isEnabled = state
            
            self.updateGroupTextState()
            
        }
        
    }
    
    
    func updateGroupTextState() {
        
        var colour = NSColor.textColor
        
        if HLLDefaults.general.showNextOccurItems == false {
            colour = .disabledControlTextColor
        }
        
        
        self.groupFollowingOccurencesDescription.textColor = colour
    }
    
    @IBAction func showAllDayButtonClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
                
                var state = false
                if sender.state == .on { state = true }
                HLLDefaults.general.showAllDay = state
                
            HLLDefaultsTransfer.shared.userModifiedPrferences()
                HLLEventSource.shared.updateEventsAsync()
                
            }
        
    }
    
    @IBAction func showPercentageClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
              
              var state = false
              if sender.state == .on { state = true }
              HLLDefaults.general.showPercentage = state
                  
              }
        
    }
    
    
    
    @IBAction func showLocationsButtonClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
             
             var state = false
             if sender.state == .on { state = true }
             HLLDefaults.general.showLocation = state
                 
             
             
              HLLEventSource.shared.updateEventsAsync()
                 
        }
        
    }
    
    @IBAction func showAllDayMenuClicked(_ sender: NSPopUpButton) {
        
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
    
    
}
