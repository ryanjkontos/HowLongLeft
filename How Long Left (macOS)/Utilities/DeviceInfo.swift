//
//  DeviceInfo.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 16/6/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


class Mac {
    
    static var current = Mac()
    
    var serialNumber: String
    
    init() {
        
    let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));
    let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey as CFString, kCFAllocatorDefault, 0);
                   IOObjectRelease(platformExpert);
    self.serialNumber = (serialNumberAsCFString?.takeUnretainedValue() as? String) ?? ""
                   
    }
    
}
