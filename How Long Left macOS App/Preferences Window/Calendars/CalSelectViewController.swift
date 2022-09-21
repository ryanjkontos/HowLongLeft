//
//  CalSelectViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 27/2/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import EventKit

class calSelectViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, CalendarCellDelegate {
    
    var cals = [EKCalendar]()
    var selectedCals = [EKCalendar]()
    
    override func viewDidAppear() {
        
        
        cals = HLLEventSource.shared.getCalendars()
        
        
        for item in HLLDefaults.calendar.enabledCalendars {
            
            for cal in cals {
                
                if cal.calendarIdentifier == item {
                    
                    selectedCals.append(cal)
                    
                }
                
                
            }
            
            
        }
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        updateSelectAllButton()
        
    }
    
    @IBOutlet weak var selectAllButton: NSButton!
    var saState = false
    
    @IBAction func selecrAllButton(_ sender: Any) {
        
        if saState == true {
            
            selectedCals = cals
            
        } else {
            
            selectedCals = [EKCalendar]()
            
        }
        
        tableView.reloadData()
        updateSelectAllButton()
        outputSelectedArrayToDefaults()
        
    }
    
    
    func cellClicked(calendar: EKCalendar, state: Bool) {
        
        if state == true {
            
            selectedCals.append(calendar)
            
        } else {
            
            if let index = selectedCals.firstIndex(where: {cal in
                
                return cal.calendarIdentifier == calendar.calendarIdentifier
                
            }) {
                
                selectedCals.remove(at: index)
                
            }
            
            
            
        }
        
        for item in selectedCals {
            
            print("Selected Cal: \(item.title)")
            
        }
        
        outputSelectedArrayToDefaults()
        updateSelectAllButton()
        
    }
    
    func updateSelectAllButton() {
        
        if selectedCals.count == cals.count {
            
            selectAllButton.title = "Enable All"
            saState = false
            
        } else {
            
            selectAllButton.title = "Disable All"
            saState = true
        }
        
        
        
    }
    
    
    
    
    
    
    
    @IBOutlet weak var tableView: NSTableView!
    
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return cals.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CalCell"), owner: nil) as? calendarItemRow {
            
            var isSelected = false
            
            if selectedCals.contains(cals[row]) {
                
                isSelected = true
                
                
            }
            
            
            cell.setup(delegate: self, calendar: cals[row], enabled: isSelected)
            
            return cell
            
        }
        
        return nil
        
    }
    
    func outputSelectedArrayToDefaults() {
        
        var idArray = [String]()
        
        for cal in selectedCals {
            
            idArray.append(cal.calendarIdentifier)
            
            
        }
        
        var disabledArray = [String]()
        
        for calendar in cals {
            
            if selectedCals.contains(calendar) == false {
                
                disabledArray.append(calendar.calendarIdentifier)
                
            }
            
            
            
            
        }
        
        HLLDefaults.calendar.disabledCalendars = disabledArray
        
        
        HLLDefaults.calendar.enabledCalendars = idArray
        
          NotificationCenter.default.post(name: Notification.Name("updatedCalendars"), object: nil)
    
        
        
        
    }
    
    override func viewWillDisappear() {
        outputSelectedArrayToDefaults()
        
    }
    
    @IBAction func doneClicked(_ sender: NSButton) {
        
        self.view.window?.performClose(nil)
        
    }
    
    
}

class calendarItemRow: NSTableCellView {
    
    @IBOutlet weak var check: NSButton!
    var delegate: CalendarCellDelegate?
    var cal: EKCalendar!
    
    func setup(delegate del: CalendarCellDelegate, calendar: EKCalendar, enabled: Bool) {
        
        delegate = del
        cal = calendar
        if enabled == true {
            
            check.state = .on
        }
        
        check.title = cal.title
    }
    
    @IBAction func checkClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
            self.delegate?.cellClicked(calendar: self.cal, state: self.check.state == .on)
        }
        
        print("Clicked")
        
    }
    
    
    
}

protocol CalendarCellDelegate {
    func cellClicked(calendar: EKCalendar, state: Bool)
}


class calSelectWindow: NSWindowController {
    
    override func windowDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeCurrent), name: Notification.Name("closingCalPrefsWindow"), object: nil)
        
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        window?.styleMask.remove(.resizable)
        window?.title = "How Long Left Calendars"
        
    }
    
    @objc func closeCurrent() {
        
        window?.close()
        
    }
    
}
