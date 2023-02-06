//
//  CNAlertSelectTypeViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 8/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

class CNAlertSelectTypeViewController: NSViewController {
    
    let alertsStoryboard = NSStoryboard(name: "CustomNotificationsAlerts", bundle: nil)
    
    var selectedType: HLLNTriggerType = .timeInterval(.timeUntil)
    
    var host: CNSessionHandler?
    
    @IBOutlet weak var timeUntilTypeButton: NSButton!
    @IBOutlet weak var timeRemainingTypeButton: NSButton!
    @IBOutlet weak var percentageCompleteTypeButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeUntilTypeButton.state = .on
    }
    
    override func viewDidAppear() {
        self.view.window?.styleMask.remove(.resizable)
    }

    @IBAction func typeRadioClicked(_ sender: NSButton) {
        
        if sender == timeUntilTypeButton {
            selectedType = .timeInterval(.timeUntil)
        }
        
        if sender == timeRemainingTypeButton {
            selectedType = .timeInterval(.timeRemaining)
        }
        
        if sender == percentageCompleteTypeButton {
            selectedType = .percentageComplete
        }
        
    }
    
    @IBAction func okClicked(_ sender: NSButton) {
        
        self.host?.createNewTrigger(of: selectedType)
        self.dismiss(nil)
        
    }
    
    @IBAction func cancelClicked(_ sender: NSButton) {
        self.dismiss(nil)
    }
    
    
}

protocol ParentDismisser {
    
    func dismissParent()
    
}
