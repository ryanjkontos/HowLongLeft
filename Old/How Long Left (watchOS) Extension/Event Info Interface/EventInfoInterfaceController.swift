//
//  EventInfoInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 28/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation



class EventInfoInterfaceController: WKInterfaceController {

    var event: HLLEvent!
    var infoSource: HLLEventInfoItemGenerator!
    var timer: Timer?
    var activity: NSUserActivity?
    
    @IBOutlet weak var countdownTable: WKInterfaceTable!
    @IBOutlet weak var infoTable: WKInterfaceTable!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        countdownTable.setHidden(true)
        event = (context as! HLLEvent)
        self.setTitle(event.title)

    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        timer = Timer(timeInterval: 1, target: self, selector: #selector(updateRows), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        updateTables()
        
        let activityObject = NSUserActivity(activityType: "com.ryankontos.how-long-left.viewEventActivity")
             activityObject.title = event.title
             
            let id = event.persistentIdentifier
        
                // print("Activity id = \(id)")
        
             activityObject.addUserInfoEntries(from: ["EventID":id])
             activityObject.isEligibleForHandoff = true
             activityObject.becomeCurrent()
             self.activity = activityObject
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        timer?.invalidate()
        self.activity?.invalidate()
        super.didDeactivate()
    }
    
    
    func updateTables() {
        
        infoSource = HLLEventInfoItemGenerator(event)
        updateInfoTable()
        
        DispatchQueue.main.async {
        
            self.clearAllMenuItems()
            if let visibilityString = self.event.visibilityString?.rawValue {
            
                self.addMenuItem(with: UIImage(named: "eye.slash.fill") ?? UIImage(), title: visibilityString, action: #selector(self.toggleVisibilty))
   
        }

            
        }
        
    }
    
    @objc func toggleVisibilty() {
        
        if let visibilityString = event.visibilityString {
            EventVisibiltyActionHandler.shared.disableVisbiltyFor(visibilityString)
        }
    }
    
    @objc func select() {
        
        if HLLDefaults.general.selectedEventID == nil {
            HLLDefaults.general.selectedEventID = event.persistentIdentifier
        } else {
            HLLDefaults.general.selectedEventID = nil
        }
        
        updateTables()
        ComplicationUpdateHandler.shared.updateComplication(force: true)
        HLLDefaultsTransfer.shared.userModifiedPrferences()
        
    }
    
    func updateInfoTable() {
        
        let items = infoSource.getInfoItems(for: [.countdown, .nextOccurence, .completion, .location, .oldLocationName, .period, .start, .end, .elapsed, .duration, .calendar, .teacher])
        
        infoTable.setNumberOfRows(items.count, withRowType: "InfoCell")
        
        for (index, item) in items.enumerated() {
            
            let row = infoTable.rowController(at: index) as! EventInfoTableRow
            row.setup(with: item)
            
            // print("Setting up \(item.type)")
            
        }
        
    }
    
    @objc func updateRows() {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
        let previousEvent = self.event
            
            if let event = self.event.getUpdatedInstance() {
              
                self.event = event
                
            // Matching event still exists
            
            if event != previousEvent {
                
                // ...But has been modified
                
                DispatchQueue.main.async {
                    self.updateTables()
                    self.setTitle(event.title)
                }
            }
                
        } else {
            
            // Matching event no longer exists
            
            DispatchQueue.main.async {
                self.pop()
            }
            
        }
            
        self.infoSource = HLLEventInfoItemGenerator(self.event)
       
        let count = self.infoTable.numberOfRows
        for index in 0..<count {
            
            if let row = self.infoTable.rowController(at: index) as? EventInfoTableRow {
            
                if let info = self.infoSource.getInfoItem(for: row.infoItem.type) {
                
                if row.infoItem != info {
                    DispatchQueue.main.async {
                    row.setup(with: info)
                    }
                }
                
            } else {
                
                    DispatchQueue.main.async {
                    self.updateTables()
                    }
                
                
            }
                
            }
            
                }
                
        
            
        }
        
        
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        if table == self.infoTable {
            
            let row = table.rowController(at: rowIndex) as! EventInfoTableRow
            
            if row.infoItem.type == .nextOccurence, let nextOccur = event.followingOccurence {
                
               pushController(withName: "EventInfoView", context: nextOccur)
                
            }
            
        }
        
    }

}
