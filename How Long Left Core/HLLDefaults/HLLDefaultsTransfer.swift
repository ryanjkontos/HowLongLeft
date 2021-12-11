//
//  HLLDefaultsTransfer.swift
//  How Long Left
//
//  Created by Ryan Kontos on 18/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLDefaultsTransfer {
    
    
    static var shared = HLLDefaultsTransfer()
    
    var transferHandlers = [DefaultsTransferHandler]()
    var transferObservers = [DefaultsTransferObserver]()
    var lastSentDict = [String:Any]()
    var dateOfLatestDownload: Date?
    
    private let serialQueue = DispatchQueue(label: "GotDefaultsQueue")
    

    var whitelistedKeys = [
        
        "NamesDictionary",
        "TeachersDictionary",
        "SchoolEventDetailIndex",
        "MagdaleneModeiOS",
        
    
    ]
    
    var blacklistedKeys = [
    
        "syncPreferences"
    
    ]
    

    func addTransferHandler(_ handler: DefaultsTransferHandler) {
        self.transferHandlers.append(handler)
    }
    
     
    func addTransferObserver(_ observer: DefaultsTransferObserver) {
        self.transferObservers.append(observer)
    }
    
    func userModifiedPrferences() {
    
        DispatchQueue.main.async {
            self.transferObservers.forEach { $0.defaultsUpdated() }
        }
        
        HLLDefaults.defaults.set(CurrentDateFetcher.currentDate, forKey: "preferencesLastModifiedByUser")
        triggerDefaultsTransfer()
        
        DispatchQueue.global(qos: .default).async {
        HLLEventSource.shared.updateEventPool()
        }
        
    }
     
    let prefsQueue = DispatchQueue(label: "PreferencesLoadQueue")
    
    
     func gotNewPreferences(_ newPreferences: [String:Any]) {
        
        var prefs = newPreferences
        
            let date = CurrentDateFetcher.currentDate
            self.dateOfLatestDownload = date
            
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.7) {
          
            if date == self.dateOfLatestDownload {
            
      //   print("Downloaded new preferences from paired device")
         
            for item in prefs {
                
                 
                 
                
                if item.key == "ComplicationPurchased" {
                    #if os(watchOS)
                    HLLDefaults.defaults.set(item.value, forKey: item.key)
                    #else
                    prefs[item.key] = nil
                    #endif
                }
                 
                 
                
                if self.whitelistedKeys.contains(item.key) {
                    HLLDefaults.defaults.set(item.value, forKey: item.key)
                    
                }
                
                
                    
                    
            }
                
                
            if HLLDefaults.watch.syncPreferences == false {
                return
            }
                
                
         if let newModificationDate = prefs["preferencesLastModifiedByUser"] as? Date {
             
             var currentModificationDate = HLLDefaults.defaults.object(forKey: "preferencesLastModifiedByUser") as? Date
         
             if currentModificationDate == nil {
               //  print("Current modification date was nil, setting to old")
                 currentModificationDate = Date.distantPast
             }
             
             if newModificationDate.timeIntervalSince(currentModificationDate!) > 0 {
                 
               //  print("New preferences are more recent than the current ones, replacing them")
                 
                 for item in prefs {
                     
                       
                     HLLDefaults.defaults.set(item.value, forKey: item.key)
                         
                     
                     
                 }
                
              
                
                 DispatchQueue.main.async {
                     self.transferObservers.forEach { $0.defaultsUpdated() }
                 }
                HLLEventSource.shared.asyncUpdateEventPool()
                 print("PoolC4")
                    
                
                 
             } else {
                 
                HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
                 print("New preferences are older than current, keeping the current ones")
                 
             }
             
         } else {
             
             print("Remote modified date was nil")
             
         }
                
            } else {
                
                print("Ignoring download because of a newer version")
                
            }
         
        }
         
     }
    
    func createDictionaryOfUserDefaultsStringValues() -> [String:String] {
        
        var returnDict = [String:String]()
        
        let rep = HLLDefaults.defaults.dictionaryRepresentation()
        
        for item in rep {
            
            if let value = item.value as? String {
                
                returnDict[item.key] = value
                
            }
            
        }
        
        return returnDict
        
    }
     
     func triggerDefaultsTransfer() {
         
        
         DispatchQueue.global(qos: .default).async {
         
            
         var transferDictionary = [String:Any]()
         
         let defaultsDictionary = HLLDefaults.defaults.dictionaryRepresentation()
         
         for item in defaultsDictionary {
                 

            
            if self.blacklistedKeys.contains(item.key) {
                continue
            }
                                    
            transferDictionary[item.key] = item.value
                   
         }
         
         if !transferDictionary.isEmpty {
             
            self.transferHandlers.forEach {$0.transferDefaultsDictionary(transferDictionary)}
            
         
         }
             
         }
     }

}
