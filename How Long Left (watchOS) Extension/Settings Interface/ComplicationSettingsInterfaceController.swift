//
//  ComplicationSettingsInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 24/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation


class ComplicationSettingsInterfaceController: WKInterfaceController {

    @IBOutlet weak var showEventsToggle: WKInterfaceSwitch!
    
    override func awake(withContext context: Any?) {
        HLLDefaultsTransfer.shared.addTransferObserver(self)
        super.awake(withContext: context)
        setup()
        
    }
    
    func setup() {
       
        if HLLDefaults.complication.complicationPurchased {
        
            showEventsToggle.setOn(HLLDefaults.complication.complicationEnabled)
        
        } else {
            
            showEventsToggle.setOn(false)
            
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        setup()
    
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func showEventsToggled(_ value: Bool) {
        
        if HLLDefaults.complication.complicationPurchased {
            
            HLLDefaults.complication.complicationEnabled = value
            
        } else {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                
                self.showEventsToggle.setOn(false)
                
            })
            
            let action = WKAlertAction(title: "OK", style: .default, handler: {})
            
            self.presentAlert(withTitle: "Complication Not Purchased", message: "You can purchase it using the How Long Left app on your iPhone. Make sure your Apple Watch is connected to your iPhone.", preferredStyle: .alert, actions: [action])
            
        }
        
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
    
    
}

extension ComplicationSettingsInterfaceController: DefaultsTransferObserver {
    
    func defaultsUpdated() {
        
        DispatchQueue.main.async {
            self.setup()
        }
        
    }
    
}
