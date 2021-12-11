//
//  CalendarSettingsInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 25/1/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import UIKit
import WatchKit
import EventKit

class CalendarItemRom: NSObject {
    
    @IBOutlet var titleLable: WKInterfaceLabel!
    
}


class CalendarSettingsInterfaceController: WKInterfaceController, DataSourceChangedDelegate {
    
    func userInfoChanged() {
        reloadTable()
        
    }
    
    @IBOutlet var table: WKInterfaceTable!
    let cal = EventDataSource.shared
    let defaults = HLLDefaults.defaults
    
    override func willActivate() {
        WatchSessionManager.sharedManager.addDataSourceChangedDelegate(delegate: self)
        reloadTable()
    }
    
    override func didDeactivate() {
        WatchSessionManager.sharedManager.removeDataSourceChangedDelegate(delegate: self)
    }
    
    func reloadTable() {
        
        var setcals = [EKCalendar]()
        
        if let storedIDS = defaults.stringArray(forKey: "setCalendars") {
            
            for id in storedIDS {
                
                for calendar in cal.getCalendars() {
                    
                    if calendar.calendarIdentifier == id {
                        
                        setcals.append(calendar)
                        
                        
                    }
                    
                }
                
                
            }
            
            
        }
        
        table.setNumberOfRows(setcals.count, withRowType: "CalRow")
        for (index, calItem) in setcals.enumerated() {
            
            let row = self.table.rowController(at: index) as! CalendarItemRom
            
            row.titleLable.setText(calItem.title)
            
        }
        
    }
    
    

}
