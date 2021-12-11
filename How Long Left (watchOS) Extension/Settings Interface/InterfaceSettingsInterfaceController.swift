//
//  GeneralSettingsInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 1/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation



class InterfaceSettingsInterfaceController: WKInterfaceController {

    @IBOutlet weak var largeCountdownButton: WKInterfaceSwitch!
    @IBOutlet weak var showUpcomingSwitch: WKInterfaceSwitch!
    @IBOutlet weak var showCurrentFirstSwitch: WKInterfaceSwitch!
    @IBOutlet weak var showOneEventSwitch: WKInterfaceSwitch!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setup()
    }
    
    func setup() {
        
        largeCountdownButton.setOn(HLLDefaults.watch.largeCell)
        showUpcomingSwitch.setOn(HLLDefaults.watch.showUpcoming)
        showCurrentFirstSwitch.setOn(HLLDefaults.watch.showCurrentFirst)
        
        showOneEventSwitch.setOn(HLLDefaults.watch.showOneEvent)
        showCurrentFirstSwitch.setEnabled(HLLDefaults.watch.showUpcoming)
        
        
    }

    override func willActivate() {
        super.willActivate()
        setup()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func largeCountdownTapped(_ value: Bool) {
        
        
        HLLDefaults.watch.largeCell = value
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
        setup()
    }
    
    @IBAction func showUpcomingTapped(_ value: Bool) {
        
        HLLDefaults.watch.showUpcoming = value
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
        setup()
        
    }
    
    @IBAction func showCurrentEventsFirstTapped(_ value: Bool) {
    
        HLLDefaults.watch.showCurrentFirst = value
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
        setup()
    }
    
    
    @IBAction func showOneEventTapped(_ value: Bool) {
        
        HLLDefaults.watch.showOneEvent = value
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
        setup()
        
    }
    
    
}
