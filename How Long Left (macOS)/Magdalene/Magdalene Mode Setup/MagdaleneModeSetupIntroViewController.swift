//
//  MagdaleneModeSetupIntroViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 20/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
/*
class MagdaleneModeSetupIntroViewController: NSViewController {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var reasonLabel: NSTextField!
    var state: SchoolEventDownloadNeededStatus {
        
        get {
            
            return (parentController.representedObject as! SchoolEventDownloadNeededStatus)
            
        }
        
    }
    
    var parentController: ControllableTabView {
        
        get {
            
            return (self.parent as! ControllableTabView)
            
        }
        
    }
    
    override func viewWillAppear() {
        
        switch state {
        case .notNeeded:
            self.reasonLabel.isHidden = true
        case .neededDueToMagdaleneWifi:
            
            self.reasonLabel.stringValue = "You're seeing this window because your Mac is connected to Magdalene Wifi."
            
        case .neededDueToPastInstall:
            
            self.reasonLabel.stringValue = "You're seeing this window because you have installed your timetable to your Mac in the past."
            
        }
        
        
    }
    
    @IBAction func continueClicked(_ sender: NSButton) {
        
        self.parentController.nextPage()
    }
    
    @IBAction func neverClicked(_ sender: NSButton) {
        
        
        self.view.window?.performClose(nil)
        
    }
    
    @IBAction func notNowClicked(_ sender: NSButton) {
        self.view.window?.performClose(nil)
    }
    
    
    
}*/
