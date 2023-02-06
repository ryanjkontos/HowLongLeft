//
//  RNProcess.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 22/6/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import EventKit
/*
class RNProcess {
    
    var cancelled = false
    
    deinit {
        cancelled = true
    }
    
    var previousProgress: Int?
    var delegate: RNProcessDelegate?
    var renameEventSource = HLLEventSource()
    let renameStorage = RNDataStore()
    let schoolEventModifier = SchoolEventModifier()
    
    func run() {
        
        autoreleasepool {
            
            
            HLLEventSource.isRenaming = true
            renameEventSource.addBreaks = false
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                HLLDefaults.defaults.set(0, forKey: "RenamedEvents")
                HLLDefaults.defaults.set(0, forKey: "AddedBreaks")
                
                self.delegate?.setStatusString("Finding events to rename...")
                self.delegate?.log("Starting RNProcess")
                let renameItems = self.renameStorage.readEnabledItemsFromDefaults()
                var renameDictionary = [String:String]()
                
                for item in renameItems {
                    
                    renameDictionary[item.oldName] = item.newName
                    
                }
                
                self.delegate?.log("renameDictionary has \(renameDictionary.count) values")
                
                if renameDictionary.count == 0 {
                    
                    self.delegate?.log("(That may be a problem)")
                    
                }
                
                // print("SA1")
                
                let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: CurrentDateFetcher.currentDate)))!
                
                let endDate = Calendar.current.date(byAdding: DateComponents(year: 1), to: startDate)!
                
                var events = self.renameEventSource.getEventsFromCalendar(start: startDate, end: endDate)
                events = self.schoolEventModifier.modify(events: events, addBreaks: false)
                
                self.delegate?.log("Found \(events.count) events")
                
                var renameEvents = [HLLEvent]()
                
                for event in events {
                    
                    if renameDictionary.keys.contains(event.originalTitle) {
                        
                        renameEvents.append(event)
                        
                    }
                    
                }
                
                self.delegate?.log("Matched \(renameEvents.count) found events to a renameDictionaryItem")
                
                let doBreaks = !HLLDefaults.defaults.bool(forKey: "RNNoBreaks")

                self.delegate?.log("doBreaks is \(doBreaks)")
                
                var breaksArray = [HLLEvent]()
                
                if doBreaks {
                    
                    let breaks = MagdaleneBreaks()
                    breaksArray = breaks.getBreaks(events: events, overrideDefaults: true)
                    
                    self.delegate?.log("There are \(breaksArray.count) breaks to be created")
                    
                    for event in breaksArray {
                        
                        // print("Break: \(event.title), \(event.startDate.formattedDate()), \(event.startDate.formattedTime())")
                        
                    }
                    
                }
                
                if renameEvents.isEmpty == false {
                
                var renamingStatusString = "Renaming \(renameEvents.count) events..."
                    
                if breaksArray.isEmpty == false {
                    
                    renamingStatusString = "Step 1/2: \(renamingStatusString)"
                    
                }
                
                self.delegate?.setStatusString(renamingStatusString)
                
                
                self.delegate?.log("Renaming \(renameEvents.count) events from \(renameEvents.first!.startDate.formattedDate()) to \(renameEvents.last!.endDate.formattedDate())")
                
                
                for (index, event) in renameEvents.enumerated() {
                    
                    let renamedCount = index+1
                    
                    if self.cancelled == true {
                        
                        // print("Cancelling")
                        return
                        
                    }
                    
                    if let newName = renameDictionary[event.originalTitle] {
                        
                        if let oldEk = event.EKEvent {
                            
                            oldEk.title = newName
                            oldEk.calendar = event.calendar!
                            oldEk.startDate = event.startDate
                            oldEk.endDate = event.endDate
                        
                            do {
                                try self.renameEventSource.eventStore.save(oldEk, span: .thisEvent, commit: true)
                            } catch {
                                
                                // print("it didn't work because \(error)")
                            }
                            
                            let doubleCounter = Double(renamedCount)
                            let doubleTotal = Double(renameEvents.count)
                            
                            let progress = doubleCounter/doubleTotal*100
                            
                            self.delegate?.log("Renamed \(renamedCount)/\(renameEvents.count) events: \(newName)")
                            HLLDefaults.defaults.set(renamedCount, forKey: "RenamedEvents")
                            self.delegate?.setProgress(progress)
                            
                        }
                        
                    }
                    
                }
                    
                } else {
                    
                    self.delegate?.setProgress(100)
                    self.delegate?.setStatusString("No events to rename")
                    self.delegate?.log("Aborting rename stage because there are no events to rename")
                    
                    if breaksArray.isEmpty == false {
                        
                        self.delegate?.log("Will still continue to add breaks")
                        
                    }
                    
                    
                }
                
                if self.cancelled == true {
                    
                    self.renameEventSource.eventStore.reset()
                    // print("Cancelling")
                    return
                    
                }
                
                if breaksArray.isEmpty == false {
                    
                    var breaksStatusString = "Adding \(breaksArray.count) breaks..."
                    
                    if !renameEvents.isEmpty {
                        
                        breaksStatusString = "Step 2/2: \(breaksStatusString)"
                        
                    }
                    
                    self.delegate?.setStatusString(breaksStatusString)
                    //self.UIDelegate?.setProgress(0.0)
                    
                    HLLDefaults.defaults.set(0, forKey: "AddedBreaks")
                    
                    for (index, breakEvent) in breaksArray.enumerated() {
                        
                        let addedCount = index+1
                        
                        let event = EKEvent(eventStore: self.renameEventSource.eventStore)
                        event.title = breakEvent.title
                        event.startDate = breakEvent.startDate
                        event.endDate = breakEvent.endDate
                        event.calendar = breakEvent.associatedCalendar
                        
                        do {
                            try self.renameEventSource.eventStore.save(event, span: .thisEvent, commit: true)
                            
                        } catch {
                            
                            // print("Break didn't work cuz \(error)")
                        }
                        
                        let doubleCounter = Double(addedCount)
                        let doubleTotal = Double(breaksArray.count)
                        
                        let progress = doubleCounter/doubleTotal*100
                        
                        self.delegate?.log("Added \(addedCount)/\(breaksArray.count) breaks: \(breakEvent.title)")
                        HLLDefaults.defaults.set(addedCount, forKey: "AddedBreaks")
                        
                        let DBIProgress = Int(progress)
                        
                        if let prev = self.previousProgress {
                            
                            if DBIProgress > prev {
                                
                                self.delegate?.setProgress(Double(DBIProgress))
                                
                            }
                            
                        } else {
                            
                            self.delegate?.setProgress(Double(DBIProgress))
                            
                        }
                        
                        self.previousProgress = DBIProgress
                    }
                    
                }
                
                
                if self.cancelled == true {
                    
                    self.renameEventSource.eventStore.reset()
                    // print("Cancelling")
                    return
                    
                }
                
                self.delegate?.processStateChanged(to: .Done)
                self.renameEventSource.eventStore.reset()
                HLLEventSource.isRenaming = false
                //self.UIDelegate?.setStatusString("Renaming complete")
                
            }
            
            
            
        }
        
    }
    
    
}
*/
