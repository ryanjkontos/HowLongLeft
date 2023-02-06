//
//  RenamePreferencesUI.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/7/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa
import Preferences

final class RenamePreferenceViewController: NSViewController, Preferenceable {
    let toolbarItemTitle = "Rename"
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    
    override var nibName: NSNib.Name? {
        return "RenamePreferencesView"
    }
    
    @IBOutlet weak var spinner: NSProgressIndicator!
    @IBOutlet weak var launchButton: NSButton!
    @IBOutlet weak var autoPromptButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        DispatchQueue.main.async {
        RNUIManager.shared.present()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.8, execute: {
            
            self.view.window?.performClose(nil)
            
        })
        
    }
    }
    
}
