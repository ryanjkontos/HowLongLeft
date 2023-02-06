//
//  SchoolEventDetailIndexer.swift
//  How Long Left
//
//  Created by Ryan Kontos on 15/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class SchoolEventDetailIndexBuilder {
    
    static var shared = SchoolEventDetailIndexBuilder()
    
    var locationIndex = [String:String]()
    var teacherIndex = [String:String]()
    
   /* func buildNewIndexFrom(events: [HLLEvent]) {
        
        var newIndex = [String:[String:String]]()
        
        if let storedIndex = HLLDefaults.defaults.object(forKey: "StoredIndex") as? [String:[String:String]] {
            newIndex = storedIndex
        }
        
        for event in events {
            
            var dataDict = [String:String]()
            dataDict["timetableid"] = event.schoolEventIdentifier
            
            if let location = event.fullLocation {
                dataDict["location"] = location
            } else {
                dataDict["location"] = nil
            }
            
            if let teacher = event.teacher {
                dataDict["teacher"] = teacher
            } else {
                dataDict["teacher"] = nil
            }
            
            newIndex[event.identifier] = dataDict

        }
        
        HLLDefaults.defaults.set(newIndex, forKey: "StoredIndex")
        
        var idLocationArray = [String:[String]]()
        var idTeacherArray = [String:[String]]()
        
        for item in newIndex.values {
            
            if let id = item["timetableid"] {
            
            if let storedLocation = item["locations"] {
                
                if var array = idLocationArray[id] {
                    array.append(storedLocation)
                    idLocationArray[id] = array
                } else {
                    idLocationArray[id] = [storedLocation]
                }
                
            }
                
            if let storedTeacher = item["locations"] {
                
                if var array = idTeacherArray[id] {
                    array.append(storedTeacher)
                    idTeacherArray[id] = array
                } else {
                    idTeacherArray[id] = [storedTeacher]
                }
                
            }
            
            
            }
            
        }
        
        self.locationIndex = idLocationArray
        self.teacherIndex = idTeacherArray
        
    }*/
    
   /* func buildIndexFrom(events: [HLLEvent]) {
        
        #if os(watchOS)
        
            if let dict = HLLDefaults.defaults.object(forKey: "SchoolEventDetailIndex") as? [String:[String:String]] {
                self.index = dict
            }
            
        
        #else
        
        if HLLDefaults.magdalene.showChanges == false {
            index.removeAll()
            return
        }
        
        var eventsDictionary = [String:[HLLEvent]]()
        
        for event in events {
            
            if event.startDate.year() != CurrentDateFetcher.currentDate.year() {
                continue
            }
            
            if eventsDictionary.keys.contains(event.schoolEventIdentifier) {
                
                if !eventsDictionary[event.schoolEventIdentifier]!.contains(event) {
                                   
                    var array = eventsDictionary[event.schoolEventIdentifier]!
                    array.append(event)
                    eventsDictionary[event.schoolEventIdentifier] = array
        
                }
                               
            } else {
                
                eventsDictionary[event.schoolEventIdentifier] = [event]
                
            }
            
        }
        
        var newIndex = [String:[String:String]]()
        
        for item in eventsDictionary {
            
            
            var locationsArray = [String]()
            var teachersArray = [String]()
            
            for event in item.value {
                
                if let location = event.location {
                    locationsArray.append(location)
                }
                
                if let teacher = event.teacher {
                    teachersArray.append(teacher)
                }
                
            }
            
            var dataDict = [String:String]()
            
            if let mostFrequentLocation = mostFrequent(array: locationsArray) {
                dataDict["location"] = mostFrequentLocation
            }
            
            if let mostFrequentTeacher = mostFrequent(array: teachersArray) {
                dataDict["teacher"] = mostFrequentTeacher
            }
            
            
            
            newIndex[item.key] = dataDict
            
        }

        HLLDefaults.defaults.set(newIndex, forKey: "SchoolEventDetailIndex")
        
        if newIndex != self.index {
            HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
            self.index = newIndex
        }
        
        #endif
        
    } */
    
    func mostFrequent<T: Hashable>(array: [T]) -> T? {

        let counts = array.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        return counts.max(by: { $0.1 < $1.1 })?.key
         
    }
    
}

class SchoolEventDetails {
    
    var location: String?
    var teacher: String?
    
    internal init(location: String?, teacher: String?) {
        self.location = location
        self.teacher = teacher
    }
    
}


