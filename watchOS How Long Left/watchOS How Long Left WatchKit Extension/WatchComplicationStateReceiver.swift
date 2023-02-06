//
//  WatchComplicationStateReceiver.swift
//  How Long Left
//
//  Created by Ryan Kontos on 27/11/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation



class WatchComplicationStateReceiver: HLLWCDataObserver {
   
    
    init() {
        HLLWCDataReceiver.shared.register(self, forKey: complicationActivatedKey)
    }
    
    func handleWCData(object: Any, for key: String) {
        
        guard key == complicationActivatedKey else { return }
        guard let result = object as? Bool else { return }
        if result { HLLDefaults.complication.complicationPurchased = true }
        ComplicationController.updateComplications(forced: false)
        
        
        
    }
    
    func updateForCloud() {
        
       /* if HLLDefaults.cloudDefaults.bool(forKey: complicationActivatedKey) == true {
            HLLDefaults.complication.complicationPurchased = true
            ComplicationStatusLogger.log("\(Date().formattedTime()): Enabled complication from cloud!")
        } */
         
        //ComplicationController.updateComplications(forced: false)
    }
    
    
}
