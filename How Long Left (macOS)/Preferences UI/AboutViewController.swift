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


final class aboutViewController: NSViewController, Preferenceable {
    let toolbarItemTitle = "About"
    let toolbarItemIcon = NSImage(named: "logo")!
    @IBOutlet weak var appIconButton: NSButton!
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    @IBOutlet weak var devLabel: NSTextField!
    
    
    
    override var nibName: NSNib.Name? {
        return "AboutView"
    }
    
    override func viewWillAppear() {
        
        if SchoolAnalyser.privSchoolMode == .Magdalene {
            
            switch Edition.shared.getCurrentEdition() {
            case .None:
                break
            case .Boiz:
              //  appIconButton.isEnabled = true
                nameLabel.stringValue = "How Long Left: The Boiz Edition"
            case .Gay:
                nameLabel.stringValue = "How Long Left Gay Edition"
            }
            
            
        }
        
        let version = Version.currentVersion
        
        if NSEvent.modifierFlags.contains(NSEvent.ModifierFlags.option) {
            
            versionLabel.stringValue = "Version \(version) (\(Version.buildVersion))"
            
        } else {
            
            versionLabel.stringValue = "Version \(version)"
        }
        
        
        
        if SchoolAnalyser.privSchoolMode == .Magdalene || MagdaleneWifiCheck().isOnMagdaleneWifi() {
            
            let inYear = Date().year()-2008
            
            if inYear > 12 {
                
                devLabel.stringValue = "Developed by Ryan Kontos, a former student at Magdalene."
                
            } else if inYear < 11 {
                
                devLabel.stringValue = "Developed by Ryan Kontos, a student at Magdalene."
                
            } else {
                
                devLabel.stringValue = "Developed by Ryan Kontos, a Year \(inYear) student at Magdalene."
                
            }
            
            
            
        } else {
            
            devLabel.stringValue = "Developed by Ryan Kontos in Sydney, Australia."
            
        }
        
        
        
        
    }
    
    @IBAction func githubButtonClicked(_ sender: NSButton) {
        
        if let url = URL(string: "https://github.com/ryankontos") {
            NSWorkspace.shared.open(url)
            
        }
        
    }
    
    
    @IBAction func twitterButtonClicked(_ sender: NSButton) {
        
        if let url = URL(string: "https://twitter.com/ryanjkontos") {
            NSWorkspace.shared.open(url)
            
        }
        
    }
    
    @IBAction func writeReviewClicked(_ sender: NSButton) {
        
        if #available(OSX 10.14, *) {
           
            if let url = URL(string: "macappstore://itunes.apple.com/app/id1388832966?action=write-review") {
                NSWorkspace.shared.open(url)
                
            }
            
        } else {
            
            if let url = URL(string: "macappstore://itunes.apple.com/app/id1388832966?mt=12") {
                NSWorkspace.shared.open(url)
                
            }
            
        }
        
        
        
    }
    
    @IBAction func appIconClicked(_ sender: NSButton) {
        
        if Edition.shared.getCurrentEdition() == .Boiz {
            
            
            
        }
        
        
    }
    
    
    
}
