//
//  GeneralPreferenceViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa


/*
final class MagdaleneNotSetupPreferenceViewController: NSViewController, PreferencePane {
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.magdaleneNotSetup
    var preferencePaneTitle: String = "Magdalene"
    @IBOutlet weak var promptCheckBox: NSButton!
    
    let toolbarItemIcon = PreferencesGlobals.magdaleneImage
    
    override var nibName: NSNib.Name? {
        return "NotSetUpMagdalenePreferencesView"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 529, height: 155)
        
        if HLLDefaults.magdalene.promptToSetUp {
            promptCheckBox.state = .on
        } else {
            promptCheckBox.state = .off
        }
        
    }
    
    @IBAction func launchCompassHelperClicked(_ sender: NSButton) {
        
        MagdaleneModeSetupPresentationManager.shared.presentMagdaleneModeSetup(with: .notNeeded)
        
    }
    
    @IBAction func promptCheckboxClicked(_ sender: NSButton) {
        
        if sender.state == .on {
            HLLDefaults.magdalene.promptToSetUp = true
        } else {
            HLLDefaults.magdalene.promptToSetUp = false
        }
        
    }
    
}
*/
