//
//  MapMenuItemHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 23/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import CoreLocation

/*class MapMenuItemHandler {
    
    static var shared = MapMenuItemHandler()
    
    @objc func openMapsFor(sender: NSMenuItem) {
        
        if let event = sender.representedObject as? HLLEvent {
            
            if let location = event.location, let locationItem = EventLocationIndexer.shared.index[location] {
                
                let latitude: CLLocationDegrees = locationItem.coordinate.latitude
                let longitude: CLLocationDegrees = locationItem.coordinate.longitude

                let regionDistance:CLLocationDistance = 100
                let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
                let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = location
                mapItem.openInMaps(launchOptions: options)
                
                
            }
            
        }
        
    }
    
}*/
