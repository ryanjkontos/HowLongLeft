//
//  EventLocationStore.swift
//  How Long Left
//
//  Created by Ryan Kontos on 17/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import Foundation
import CoreLocation

class EventLocationStore: ObservableObject {
    
    
    static var shared: EventLocationStore!
    private var locationDict = [String: CLLocationCoordinate2D]()
    private var noResultLocations = Set<String>()
    
    private let geocoder = CLGeocoder()
    
    init() {
        
        HLLEventSource.shared.addEventPoolObserver(self)
        
    }
    
    private func processEvents(events: [HLLEvent]) async {
        
        var changesMade = false
        
        for event in events {
            
            guard let location = event.location else { continue }
            if locationDict.keys.contains(location) { continue }
            if noResultLocations.contains(location) { continue }
            print("Attempting geocode for \(location)")
            
            do {
                
                let placemarks = try await geocoder.geocodeAddressString(location)
                guard let coordinate = placemarks.first?.location?.coordinate else { continue }
                locationDict[location] = coordinate
                changesMade = true
                
            } catch {
                
                let error = error as! CLError
                
                switch error.code {
                case .geocodeFoundNoResult:
                    noResultLocations.insert(location)
                case .geocodeFoundPartialResult:
                    noResultLocations.insert(location)
                default:
                    break
                }
                
            }
            
           
        }
        
        if changesMade {
            objectWillChange.send()
        }
        
    }
    
    func getLocation(for address: String?) -> CLLocationCoordinate2D? {
        
        if let address = address {
            if let item = locationDict[address] { return item}
        }
        return nil
        
    }
    
}

extension EventLocationStore: EventPoolUpdateObserver {
    
    func eventPoolUpdated() {
        
        Task {
            await self.processEvents(events: HLLEventSource.shared.eventPool)
        }
        
    }
    
}

struct IdentifiableLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
