//
//  EventsPreferenceViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import Preferences
import LaunchAtLogin
import EventKit

final class EventsPreferenceViewController: NSViewController, PreferencePane, NSTableViewDataSource, NSTableViewDelegate, EventSourceUpdateObserver, EventHidingObserver {
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.events
    var preferencePaneTitle: String = "Hidden"

    @IBOutlet weak var table: NSTableView!
    @IBOutlet weak var unhideButton: NSButton!
    
    
    var currentDate = Date().startOfDay()
    
    var events = [HLLStoredEvent]()

    
    let toolbarItemIcon = PreferencesGlobals.hideImage
    
    override var nibName: NSNib.Name? {
        return "EventsPreferencesView"
    }
    
   
    
    override func viewDidLoad() {
        
     //   askCheckbox.state = HLLDefaults.general.askToHide.controlStateValue
        
        HLLStoredEventManager.shared.observers.append(self)
        HLLEventSource.shared.addeventsObserver(self)
        let textCell = NSNib(nibNamed: "EventTableCell", bundle: Bundle.main)
        table.register(textCell, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "EventTableCell"))
        
        self.preferredContentSize = CGSize(width: 418, height: 453)
        
        table.dataSource = self
        table.delegate = self
        update()
    
    }
    
    func update() {
        getEvents()
        table.reloadData()
        updateInterfaceForSelection()
        
    }
    
    func getEvents() {
        
    
        self.events = HLLStoredEventManager.shared.hiddenEvents
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "EventTableCell"), owner: self) as! EventTableCell
        view.label.stringValue = events[row].title!
        
        return view
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        updateInterfaceForSelection()
        
        
    }
    

    func deleteSelectedEvent() {
        
        
        let selected = table.selectedRowIndexes
        
        for index in selected {
            
            HLLStoredEventManager.shared.unhideEvent(events[index])
            
        }
        
        
        update()
        
        
    }
    
    override func keyDown(with event: NSEvent) {
        
        if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
            deleteSelectedEvent()
        }
        
    }
    
    @IBAction func unhideClicked(_ sender: NSButton) {
        
        deleteSelectedEvent()
    }
    
    
    func updateInterfaceForSelection() {
        
        if table.numberOfRows == 0 {
            unhideButton.isEnabled = false
            return
        }
        
        unhideButton.isEnabled = !table.selectedRowIndexes.isEmpty
        
    }
    
    func eventsUpdated() {
        DispatchQueue.main.async {
            self.update()
        }
    }
    
    
    @IBAction func askClicked(_ sender: NSButton) {
        
        HLLDefaults.general.askToHide = sender.isOn
        
        
    }
    
    func eventWasHidden(event: HLLEvent) {
        DispatchQueue.main.async {
            self.update()
        }
    }
   
}
