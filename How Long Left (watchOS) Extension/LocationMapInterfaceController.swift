//
//  LocationMapInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 30/3/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation
import CoreLocation

class LocationMapInterfaceController: WKInterfaceController {

    @IBOutlet var map: WKInterfaceMap!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    
        
        let data = context as! HLLEvent
        
        self.setTitle(data.title)
        
        if let loc = data.CLLocation {
            
           map.addAnnotation(loc.coordinate, with: .red)
            
            
        }
        
    
        
        
        
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
