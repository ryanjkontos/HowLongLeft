//
//  GeneralSettingsInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 6/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation



class GeneralSettingsInterfaceController: WKInterfaceController {

    @IBOutlet weak var showEventLocationsSwitch: WKInterfaceSwitch!
    @IBOutlet weak var showAllDayEventsSwitch: WKInterfaceSwitch!
    @IBOutlet weak var includeAllDayEventsInCurrentSwitch: WKInterfaceSwitch!
    @IBOutlet weak var showFollowingOccurencesSwitch: WKInterfaceSwitch!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        showEventLocationsSwitch.setOn(HLLDefaults.general.showLocation)
        showAllDayEventsSwitch.setOn(HLLDefaults.general.showAllDay)
        includeAllDayEventsInCurrentSwitch.setEnabled(HLLDefaults.general.showAllDay)
        includeAllDayEventsInCurrentSwitch.setOn(HLLDefaults.general.showAllDayAsCurrent)
        showFollowingOccurencesSwitch.setOn(HLLDefaults.general.showNextOccurItems)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()

    }

    func setup() {
        
        

    }
    
    
    @IBAction func showLocationsToggled(_ value: Bool) {
        
        HLLDefaults.general.showLocation = value
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
    
    @IBAction func showAllDayEventsToggled(_ value: Bool) {
        
        HLLDefaults.general.showAllDay = value
        includeAllDayEventsInCurrentSwitch.setEnabled(HLLDefaults.general.showAllDay)
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
    
    
    @IBAction func showAllDayEventsInCurrentToggled(_ value: Bool) {
        
        HLLDefaults.general.showAllDayAsCurrent = value
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
    
    @IBAction func showFollowingOccurencesToggled(_ value: Bool) {
        
        HLLDefaults.general.showNextOccurItems = value
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
    
    
}
