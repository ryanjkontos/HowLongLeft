//
//  EventLocationIndexer.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 23/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import CoreLocation

class EventLocationIndexer {
    
    static var shared = EventLocationIndexer()
    
    var index = [String:CLLocation]()
    
    func indexLocations(for events: [HLLEvent]) {
        
        DispatchQueue.global().async {
            
            for event in events {
                
                if let address = event.location {
                    
                    let geoCoder = CLGeocoder()
                    geoCoder.geocodeAddressString(address) { (placemarks, error) in
                        if let safePlacemarks = placemarks {
                            let locationItem = safePlacemarks.first?.location
                            
                            if let safeItem = locationItem {
                                
                                self.index[address] = safeItem
                            }
                            
                            
                        }
                    }
                    
                   
                    
                }
                
                
            }
            
            
        }
        
        
    }
    
    
}
