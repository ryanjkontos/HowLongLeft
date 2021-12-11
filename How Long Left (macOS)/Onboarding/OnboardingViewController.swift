//
//  OnboardingViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import AppKit
import Preferences
import LaunchAtLogin

class OnboardingViewController: NSViewController {
   
    @IBOutlet weak var launchAtLoginButton: NSButton!
    
    override func viewDidLoad() {
        
        var state = NSControl.StateValue.off
        if LaunchAtLogin.isEnabled {
            state = .on
        }
        
        launchAtLoginButton.state = state
        
    }
    
    @IBAction func continueClicked(_ sender: NSButton) {
        self.view.window?.performClose(nil)
        
    }
    
    @IBAction func preferencesClicked(_ sender: NSButton) {
        
        self.view.window?.performClose(nil)
        
        PreferencesWindowManager.shared.launchPreferences()
        
    }
    
    @IBAction func launchAtLoginClicked(_ sender: NSButton) {
        
        LaunchAtLogin.isEnabled = sender.state == .on
    }
    
    
}
