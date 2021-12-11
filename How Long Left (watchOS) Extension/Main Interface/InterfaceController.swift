//
//  MainInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 21/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, EventPoolUpdateObserver, DefaultsTransferObserver {
    
    @IBOutlet weak var eventsTable: WKInterfaceTable!
    @IBOutlet weak var noTableLabel: WKInterfaceLabel!
    @IBOutlet weak var moreUpcomingButton: WKInterfaceButton!
    
    var events = [HLLEvent]()
    
    var tableFetchedEvents = [HLLEvent]()
    
    var largeCellConfiguration = true
    var showUpcomingConfiguration = true
    var showCurrentFirstConfiguration = false
    var hideExtrasConfiguration = false
    var showOneEventOnlyConfiguration = false
    
    var rowUpdateTimer: Timer?
    
    var doneInitalLaunch = false
    
    let previousRowType = "PreviousEventRow"
    let primaryRowType = "PrimaryEventRow"
    let currentRowType = "CurrentEventRow"
    let upcomingRowType = "UpcomingEventRow"
    
    let hideablePeriods = ["H", "R", "L"]
    
    let countdownStringGenerator = CountdownStringGenerator()
    
    override func awake(withContext context: Any?) {
        
        HLLEventSource.shared.addEventPoolObserver(self)
        HLLDefaultsTransfer.shared.addTransferObserver(self)
        
        self.rowUpdateTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.asyncUpdateRows), userInfo: nil, repeats: true)
        RunLoop.main.add(self.rowUpdateTimer!, forMode: .common)
         
    }

    override func willActivate() {
        
        //self.updateRows(async: false)
        
        if doneInitalLaunch == false {
            updateTable()
            doneInitalLaunch = true
            
        } else {
            
            updateRows()
            self.updateTable()
            
            DispatchQueue.global(qos: .default).async {
                
                HLLEventSource.shared.updateEventPool()
            }
            
        }
        
        setupMenuItems()
        
    }

    override func didDeactivate() {
        super.didDeactivate()
    }
    
    func updateTable() {
        
        print("WDB: Updating table")
        var fetchedEvents = HLLEventSource.shared.getTimeline(includeUpcoming: HLLDefaults.watch.showUpcoming, chronological: !HLLDefaults.watch.showCurrentFirst)

        moreUpcomingButton.setHidden(fetchedEvents.filter({$0.completionStatus == EventCompletionStatus.Upcoming}).isEmpty)
        
             if fetchedEvents.isEmpty == false {

                 self.setNoTableText(nil)
                 
             } else if HLLEventSource.shared.neverUpdatedEventPool == false {
                 
                 if HLLEventSource.shared.access == .Denied {
                     self.setNoTableText("No Calendar Access")
                 } else {
                     self.setNoTableText("No Events Found")
                 }
                 
                 return
                 
             }
        
        if fetchedEvents != self.tableFetchedEvents || largeCellConfiguration != HLLDefaults.watch.largeCell || showUpcomingConfiguration != HLLDefaults.watch.showUpcoming || showCurrentFirstConfiguration != HLLDefaults.watch.showCurrentFirst || hideExtrasConfiguration != HLLDefaults.magdalene.hideExtras || showCurrentFirstConfiguration != HLLDefaults.watch.showOneEvent {
            
            self.tableFetchedEvents = fetchedEvents
            self.largeCellConfiguration = HLLDefaults.watch.largeCell
            self.showUpcomingConfiguration = HLLDefaults.watch.showUpcoming
            self.showCurrentFirstConfiguration = HLLDefaults.watch.showCurrentFirst
            self.hideExtrasConfiguration = HLLDefaults.magdalene.hideExtras
            self.showCurrentFirstConfiguration = HLLDefaults.watch.showOneEvent
            
            if HLLDefaults.watch.showOneEvent {
                if let first = fetchedEvents.first {
                    fetchedEvents = [first]
                }
            }
            
            
        if HLLDefaults.magdalene.hideExtras {
            
            for (index, event) in fetchedEvents.enumerated() {
                
                if let period = event.period, hideablePeriods.contains(period), index != 0, event.completionStatus != .Current {
                        
                    fetchedEvents.removeAll { $0 == event }
                    
                }
                
            }
            
        }
         
            
            self.events = fetchedEvents
            
            
            var rowTypes = [String]()
            var addedPrimary = false
            
            //let numberOfEnded = fetchedEvents.filter {$0.completionStatus == .Done}.count
            
            for event in fetchedEvents {
                
                if event.completionStatus != .Done, addedPrimary == false {
                    
                   if HLLDefaults.watch.largeCell {
                        rowTypes.append(self.primaryRowType)
                    
                       /* if event.completionStatus == .Upcoming {
                            rowTypes.append(self.upcomingRowType)
                            fetchedEvents.insert(event, at: numberOfEnded)
                        }*/
                    
                    } else {
                        rowTypes.append(self.currentRowType)
                    }
                    
                    addedPrimary = true
                    
                    
                } else {
                        
                    switch event.completionStatus {
                        
                    case .Upcoming:
                        rowTypes.append(self.upcomingRowType)
                    case .Current:
                        rowTypes.append(self.currentRowType)
                    case .Done:
                        rowTypes.append(self.previousRowType)
                        
                    }
                        
                }
            }
            
            self.eventsTable.setRowTypes(rowTypes)
            
            if fetchedEvents.count == 1, rowTypes.contains(self.primaryRowType) {
                self.eventsTable.setVerticalAlignment(.center)
            } else {
                self.eventsTable.setVerticalAlignment(.top)
            }
            
            for (index, event) in fetchedEvents.enumerated() {
                  
                let row = self.eventsTable.rowController(at: index) as! EventRow
                row.setup(event: event)
                row.updateRow()
                
            }
            
        }
        
    }
    
    func updateRows() {
        
        let count = self.eventsTable.numberOfRows
        
        for index in 0..<count {
        
            if let row = self.eventsTable.rowController(at: index) as? EventRow {
                row.updateRow()
                
                if row.rowCompletionStatus != row.event.completionStatus {
                    DispatchQueue.main.async {
                        self.updateTable()
                    }
                }
            }
            
        }
        
    }
    
    @objc func asyncUpdateRows() {
        
        DispatchQueue.global(qos: .userInteractive).async {
        
        let count = self.eventsTable.numberOfRows
        
        for index in 0..<count {
            
            if let row = self.eventsTable.rowController(at: index) as? EventRow {
                
                row.updateRow()
                
                if row.rowCompletionStatus != row.event.completionStatus {
                    DispatchQueue.main.async {
                        self.updateTable()
                    }
                }
                
            }
                
            }
            
        }
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
            if table == self.eventsTable {
            
            if let row = table.rowController(at: rowIndex) as? EventRow {
                
                let event = row.event
                self.pushController(withName: "EventInfoView", context: event)
            }
           
            
        }
            
    }
    
    func setNoTableText(_ text: String?) {
        
        let state = text == nil
        noTableLabel.setText(text)
        noTableLabel.setHidden(state)
        eventsTable.setHidden(!state)
        
    }
    
    func eventPoolUpdated() {
        print("WDB: Eventpool changed called")
        DispatchQueue.main.async {
            self.updateTable()
        }
    }
    
    func defaultsUpdated() {
        print("WDB: Defaults changed called")
        DispatchQueue.main.async {
            self.updateTable()
        }
    }
    
    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func setupMenuItems() {
        
        self.clearAllMenuItems()
        
        let image =  UIImage(named: "gear")!
        let resizedImage = imageWithImage(image: image, scaledToSize: CGSize(width: 30, height: 30))
        
        self.addMenuItem(with: resizedImage, title: "Settings", action: #selector(settingsButtonPressed))
        
    }
    
    @objc func clearSelection() {
        
        HLLDefaults.general.selectedEventID = nil
        setupMenuItems()
        ComplicationUpdateHandler.shared.updateComplication(force: true)
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
 
    @IBAction func moreUpcomingButtonTapped() {
        
        self.pushController(withName: "MoreUpcomingView", context: nil)
        
    }
    
    @objc func settingsButtonPressed() {
        
        self.pushController(withName: "SettingsMain", context: nil)
        
    }
    
    @objc func getPreferences() {
        

        
    }
    

}
