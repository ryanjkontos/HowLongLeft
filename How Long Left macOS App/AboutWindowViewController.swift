//
//  AboutWindowViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/8/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class AboutWindowViewController: NSViewController {
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var versionLabel: NSTextField!
    
    
    override func viewWillAppear() {
           
           nameLabel.stringValue = "How Long Left"
           
           let version = Version.currentVersion
           versionLabel.stringValue = "Version \(version) (\(Version.buildVersion))"
           
       }
       
    
    
}

class AboutWindowContactPopoverViewController: NSViewController {
    
    
   @IBAction func githubButtonClicked(_ sender: NSButton) {
       
       if let url = URL(string: "https://github.com/ryankontos") {
           NSWorkspace.shared.open(url)
           
       }
       
   }
   
   @IBAction func emailMeClicked(_ sender: NSButton) {
       
       if let url = URL(string: "mailto:ryanjkontos@gmail.com") {
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

    
    
}

