//
//  CalendarPreferenceViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import Foundation
import Cocoa
import Preferences
import LaunchAtLogin
import EventKit


final class CalendarPreferenceViewController: NSViewController, Preferenceable {
    let toolbarItemTitle = "Calendars"
    let toolbarItemIcon = NSImage(named: "CalIcon")!
    var calSelect : NSWindowController?
    var calSelectStoryboard = NSStoryboard()
    
    @IBOutlet weak var calInfoLabel: NSTextField!
    var timer: Timer!
    let calendarData = EventDataSource()
    
    
    override var nibName: NSNib.Name? {
        return "CalendarPreferencesView"
    }
    
    @IBAction func changeClicked(_ sender: NSButton) {
        

        if calSelect?.window?.isVisible == true {
        
        
        
        } else {
            
            self.calSelectStoryboard = NSStoryboard(name: "CalSelectStoryboard", bundle: nil)
            
            self.calSelect = self.calSelectStoryboard.instantiateController(withIdentifier: "Cal2") as? NSWindowController
            self.calSelect!.showWindow(self)
            
            
        }
            
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.calendarChanged), name: Notification.Name("updatedCalendars"), object: nil)
        calendarChanged()
        
    }
    
    
    
    
    override func viewWillDisappear() {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("updatedCalendars"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("closingCalPrefsWindow"), object: nil)
        
        
    }
    
    @objc func calendarChanged() {
        
        let count = HLLDefaults.calendar.enabledCalendars.count
                if count == 1 {
            
            calInfoLabel.stringValue = "You are currently using 1 calendar with How Long Left."
            
        } else {
            
            calInfoLabel.stringValue = "You are currently using \(count) calendars with How Long Left."
            
        }
        
        if count == calendarData.getCalendars().count, HLLDefaults.calendar.disabledCalendars.isEmpty == true {
            
            calInfoLabel.stringValue = "You are currently using all of your calendars with How Long Left."
            
        }
        
        
        
        
    }
    
    
    
    
}

class rowCheck: NSObject, NSTableViewDelegate, NSTableViewDataSource {
    
    var cals = [EKCalendar]()
    
 
    @IBOutlet weak var tableView: NSTableView!
    @IBAction func clicked(_ sender: Any) {
        
        
        
        print("Cal row clicked")
        
    }
    
    let calendarData = EventDataSource()
    let schoolAnalyzer = SchoolAnalyser()
    var titleIdentifierDictionary: [String: String] = [:]
    var identifierTitleDictionary: [String: String] = [:]
    
    override func awakeFromNib() {
     //   arrayWhenLoaded = HLLDefaults.calendar.enabledCalendars
        
        cals = self.calendarData.getCalendars()
        
        
        
        
    
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    var SAState = false
    
    
    @IBOutlet weak var selectAllButton: NSButton!
    
    
}
