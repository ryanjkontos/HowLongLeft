//
//  CloudDefaultsSynchronizer.swift
//  How Long Left
//
//  Created by Ryan Kontos on 9/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import Foundation
import os.log

class CloudDefaultsSynchronizer {
    
    private let syncKeys: [String] = []
    
    private let ModifiedyDateKey = "SettingsModifiedDate"
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(ubiquitousKeyValueStoreDidChange), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: HLLDefaults.cloudDefaults)
    }
    
    func syncDefaults() {
        HLLDefaults.cloudDefaults.synchronize()
    }
    
    @objc private func ubiquitousKeyValueStoreDidChange(notification: NSNotification) {
       
        Logger.defaultsSync.info("Got didChangeExternallyNotification")
        
        guard let userInfo = notification.userInfo else {
            return
        }
        
        guard let keys = userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] else {
            return
        }
        
        for key in keys {
            
            if syncKeys.contains(key) {
                HLLDefaults.defaults.set(HLLDefaults.cloudDefaults.value(forKey: key), forKey: key)
            }
            
        }
        

    }
    
}
