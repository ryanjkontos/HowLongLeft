//
//  RNDataStore.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 22/6/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

/*
import EventKit

class RNDataStore {
    
    var renameableItems = [RNEvent]()
    let schoolAnalyser = SchoolAnalyser()
    var modificationsMade = false
    var magdaleneTitlesCount = 0
    
    var magdaleneTitles = [String]()
    
    init() {
        
        //HLLEventSource.eventStore = EKEventStore()
        
        autoreleasepool {
        
        let defaultsOldNew = HLLDefaults.defaults.dictionary(forKey: "RenameOldNew")
        let defaultsOldEnabled = HLLDefaults.defaults.dictionary(forKey: "RenameOldEnabled")
        
        var safeOldNew = [String:String]()
        var safeOldEnabled = [String:Bool]()
        
        if defaultsOldNew != nil {
         
            safeOldNew = defaultsOldNew as! [String : String]
            
        }
        
        if defaultsOldEnabled != nil {
            
            safeOldEnabled = defaultsOldEnabled as! [String : Bool]
            
        }
    
        print("SA2")
        let yearEvents = HLLEventSource.shared.fetchEventsFromPresetPeriod(period: .ThisYear)
        
            for event in yearEvents {
                
                print("\(event.title)")
                
                
            }
            
            print("Initing RNDS with \(yearEvents.count)")
            
        magdaleneTitles = schoolAnalyser.magdaleneTitles(from: yearEvents)
        
           magdaleneTitlesCount = magdaleneTitles.count
            
        var matchedNames = [String]()
        
        for event in yearEvents {
            
            if magdaleneTitles.contains(event.originalTitle), matchedNames.contains(event.originalTitle) == false {
                
                matchedNames.append(event.originalTitle)
                
                if safeOldNew.keys.contains(event.originalTitle) == false {
                modificationsMade = true
                renameableItems.append(RNEvent(old: event.originalTitle, new: event.title))
                    
                }
                
            }
            
        }
        
        var tempRE = [RNEvent]()
        
        for item in safeOldNew {
            
            let event = RNEvent(old: item.key, new: item.value)
            tempRE.append(event)
            
        }
        
        var tempEnabled = [RNEvent]()
        
        for item in safeOldEnabled {
            
            for tempItem in tempRE {
                
                if tempItem.oldName == item.key {
                    
                    tempItem.selected = item.value
                    tempEnabled.append(tempItem)
                    
                }
                
                
            }
            
            
        }
        
        renameableItems.append(contentsOf: tempEnabled)
        
        
        saveToDefaults(items: renameableItems)
        
        }
    }
    
    func renameAvaliable() -> Bool {
        
       return magdaleneTitlesCount != 0
        
    }
    
    func saveToDefaults(items: [RNEvent]) {
        
        autoreleasepool {
        
        renameableItems = items
        
        var oldNewDict = [String:String]()
        var oldEnabledDict = [String:Bool]()
        
        for item in items {
            
            oldNewDict[item.oldName] = item.newName
            oldEnabledDict[item.oldName] = item.selected
            
        }
        
        HLLDefaults.defaults.set(oldNewDict, forKey: "RenameOldNew")
        HLLDefaults.defaults.set(oldEnabledDict, forKey: "RenameOldEnabled")
            
        }
        
    }
    
    func readFromDefaults() -> [RNEvent] {
        
        var tempEnabled = [RNEvent]()
        
        autoreleasepool {
        
        let oldNewDict = HLLDefaults.defaults.dictionary(forKey: "RenameOldNew")!
        let oldEnabledDict = HLLDefaults.defaults.dictionary(forKey: "RenameOldEnabled")!
        
        
        var tempRE = [RNEvent]()
        
        for item in oldNewDict {
            
            let event = RNEvent(old: item.key, new: item.value as! String)
            tempRE.append(event)
            
            
        }
        
        for item in oldEnabledDict {
            
            for tempItem in tempRE {
                
                if tempItem.oldName == item.key {
                    
                    tempItem.selected = item.value as! Bool
                    tempEnabled.append(tempItem)
                    
                }
                
                
            }
            
            
        }
        
        tempEnabled = tempEnabled.sorted { $0.oldName < $1.oldName }
            
        }
        
        return tempEnabled
        
    }
    
    func readEnabledItemsFromDefaults() -> [RNEvent] {
        
        let items = readFromDefaults()
        var newItems = [RNEvent]()
        
        for item in items {
            
            if item.selected == true {
                
                newItems.append(item)
                
            }
            
        }
        
        return newItems
        
        
    }
    
    
}
*/
