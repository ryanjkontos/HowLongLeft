//
//  PurchaseProViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 6/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa
import Preferences

final class PurchasedProViewController: NSViewController, PreferencePane {
  
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.purchasedPro
    var preferencePaneTitle: String = "Pro"
    
    let toolbarItemIcon = PreferencesGlobals.proImage
    
    override var nibName: NSNib.Name? {
        return "PurchasedPro"
    }
    
    override func viewDidLoad() {
           
        let confettiView = SwiftConfettiView(frame: self.view.frame)
        confettiView.type = .confetti
        confettiView.startConfetti()
        self.view.addSubview(confettiView)
        confettiView.startConfetti()
       
        self.preferredContentSize = CGSize(width: 529, height: 294)
           
    }
    
   
    
}
