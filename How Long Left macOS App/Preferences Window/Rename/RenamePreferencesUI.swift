//
//  RenamePreferencesUI.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import Preferences

final class RenamePreferenceViewController: NSViewController, PreferencePane {
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.rename
    var preferencePaneTitle: String = "Rename"
    
    let toolbarItemIcon = NSImage(named: "RenameIcon")!
    
    override var nibName: NSNib.Name? {
        return "RenamePreferencesView"
    }
    
    @IBOutlet weak var spinner: NSProgressIndicator!
    @IBOutlet weak var launchButton: NSButton!
    @IBOutlet weak var autoPromptButton: NSButton!
    
    override func viewWillAppear() {
        
        PreferencesWindowManager.shared.currentIdentifier = preferencePaneIdentifier
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 470, height: 174)
        
        spinner.isHidden = true
        
        if HLLDefaults.rename.promptToRename {
            
            autoPromptButton.state = .on
            
        } else {
            
            autoPromptButton.state = .off
            
        }
        
        
    }
    
    @IBAction func autoPromptClicked(_ sender: NSButton) {
        
        var setTo = false
        
        if sender.state == .on {
            
            setTo = true
            
        }
        
        HLLDefaults.rename.promptToRename = setTo
        
        
    }
    
    @IBAction func launchRenameClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
        
        self.launchButton.isHidden = true
        self.spinner.isHidden = false
        self.spinner.startAnimation(nil)
        DispatchQueue.global(qos: .default).async {
        RNUIManager.shared.present()
        }
       
            DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute: {
            
            self.view.window?.performClose(nil)
            
        })
        
    }
    }
    
}
