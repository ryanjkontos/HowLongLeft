//
//  CompassLaunchHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class CompassLaunchHandler {
    
    static var shared = CompassLaunchHandler()
    
    @objc func launchCompass() {
        
        DispatchQueue.main.async {
        
        if let url = URL(string: "https://mchsdow-nsw.compass.education/Organise/Calendar/") {
            NSWorkspace.shared.open(url)
            print("Compass was successfully opened")
        }
            
        }
        
    }
    
    
}
