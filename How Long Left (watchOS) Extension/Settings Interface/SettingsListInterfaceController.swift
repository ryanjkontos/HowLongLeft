//
//  SettingsListInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 29/9/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation



class SettingsListInterfaceController: WKInterfaceController, DefaultsTransferObserver {

    @IBOutlet weak var table: WKInterfaceTable!
    var tableRows = [SettingsListRowType]()
    @IBOutlet weak var syncPreferencesButton: WKInterfaceSwitch!
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        syncPreferencesButton.setOn(HLLDefaults.watch.syncPreferences)
        super.willActivate()
        HLLDefaultsTransfer.shared.addTransferObserver(self)
        setupTable()
    }
    
    func setupTable() {
        
        tableRows.removeAll()
        var rowTypes = SettingsListRowType.allCases
        
        if SchoolAnalyser.privSchoolMode != .Magdalene {
            rowTypes.removeAll {$0 == .Magdalene}
        }
        
        table.setNumberOfRows(rowTypes.count, withRowType: "TypeRow")
        
        for (index, type) in rowTypes.enumerated() {
            
            
            let row = table.rowController(at: index) as! SettingsListRow
            row.setup(type: type)
            tableRows.append(type)
            
        }
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        let type = tableRows[rowIndex]
        
        if type == .General {
            
            self.pushController(withName: "GeneralSettings", context: nil)
            
        }
        
        if type == .Calendars {
            
            self.pushController(withName: "CalendarList", context: nil)
            
        }
        
        if type == .Magdalene {
            
            self.pushController(withName: "MagdaleneSettings", context: nil)
            
        }
        
        if type == .Interface {
            
            self.pushController(withName: "InterfaceSettings", context: nil)
            
        }
        
        if type == .Complication {
            
            self.pushController(withName: "ComplicationSettingsView", context: nil)
            
        }
        
    }
    
    func defaultsUpdated() {
        setupTable()
    }
    
    @IBAction func syncPreferencesClicked(_ value: Bool) {
        
        HLLDefaults.watch.syncPreferences = true
        HLLDefaultsTransfer.shared.triggerDefaultsTransfer()
        
    }
    

}

class SettingsListRow: NSObject {
    
    @IBOutlet weak var typeLabel: WKInterfaceLabel!
    
    func setup(type: SettingsListRowType) {
        
        typeLabel.setText(type.rawValue)
        
    }
    
}

enum SettingsListRowType: String, CaseIterable {
    
    case General = "General"
    case Interface = "Interface"
    case Calendars = "Calendars"
    case Complication = "Complication"
    case Magdalene = "Magdalene"
    
    
}
