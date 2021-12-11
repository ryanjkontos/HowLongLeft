//
//  CustomNotificationPreferencesViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 9/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
import Preferences


class CustomNotificationPreferencesViewController: NSViewController, PreferencePane, NSTableViewDataSource, NSTableViewDelegate, CNTableProtocol {
    
    @IBOutlet weak var enableNotificationsButton: NSButton!
    
    @IBOutlet weak var table: NSTableView!
    @IBOutlet weak var descriptionColumn: NSTableColumn!
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.customNotifications
    var preferencePaneTitle: String = "Notifications"
    
    @IBOutlet weak var notifyWhenLabel: NSTextField!
    @IBOutlet weak var eventStartTriggerButton: NSButton!
    @IBOutlet weak var eventEndTriggerButton: NSButton!
    
    @IBOutlet weak var hotKeyOffButton: NSButton!
    @IBOutlet weak var hotkeyOptionWButton: NSButton!
    @IBOutlet weak var hotKeyCommandTButton: NSButton!
    
    @IBOutlet weak var notificationSoundsButton: NSButton!
    @IBOutlet weak var descriptionLabel: NSTextField!
    
    var sessionHandler: CNSessionHandler!
    var triggerStore = HLLNTriggerStore()
    
    @IBOutlet weak var addTriggerButton: NSButton!
    @IBOutlet weak var editButton: NSButton!
    @IBOutlet weak var duplicateButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    
    let toolbarItemIcon = PreferencesGlobals.notificationsImage
        
        override var nibName: NSNib.Name? {
            return "CustomNotificationPreferencesView"
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 595, height: 499)
    
        sessionHandler = CNSessionHandler(hostViewController: self)
        
        let checkView = NSNib(nibNamed: "CNCheckView", bundle: Bundle.main)
        let textCell = NSNib(nibNamed: "CNTextCell", bundle: Bundle.main)
        
        table.register(checkView, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CheckView"))
        table.register(textCell, forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TextCell"))
        
        table.dataSource = self
        table.delegate = self
        
        table.menu = generateRightClickMenu()
        
        table.doubleAction = #selector(editClickedRow)
        
        
        
    }
    
    override func viewWillAppear() {
        
        var setTo = NSControl.StateValue.off
        if HLLDefaults.notifications.enabled {
            setTo = .on
        }
        
        enableNotificationsButton.state = setTo
        setupOtherOptionButtons()
        
        updateButtonsFromSelection()
        update()
    }
    
    @IBAction func enableNotificationsButtonClicked(_ sender: NSButton) {
        
        HLLDefaults.notifications.enabled = sender.state == .on
        update()
        
    }
    
    
    func update() {
        
        triggerStore.updateTriggers()
        table.reloadData()
        updateButtonsFromSelection()
        
        let enabled = HLLDefaults.notifications.enabled
        
        if enabled == false {
            setSelectionState(edit: false, remove: false)
            
            notifyWhenLabel.textColor = .disabledControlTextColor
            descriptionLabel.textColor = .disabledControlTextColor
        } else {
            updateButtonsFromSelection()
            notifyWhenLabel.textColor = .textColor
            descriptionLabel.textColor = .textColor
        }
        
        table.isEnabled = enabled
        addTriggerButton.isEnabled = enabled
        
        eventEndTriggerButton.isEnabled = enabled
        eventStartTriggerButton.isEnabled = enabled
        
        MacEventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        
    }
    
    func selectTrigger(from request: HLLNNewTriggerRequest) {
        
        let triggers = triggerStore.triggers
        
        for (index, trigger) in triggers.enumerated() {
            
            if trigger.type == request.type, trigger.value == request.value {
            
                self.view.window?.makeFirstResponder(table)
                let set = IndexSet(integer: index)
                table.selectRowIndexes(set, byExtendingSelection: false)
                table.scrollRowToVisible(index)
                
            }
            
        }
        
    }

    @IBAction func addClicked(_ sender: NSButton) {
        
        sessionHandler.newTrigger()
        
    }
    
    @IBAction func editClicked(_ sender: NSButton) {
        editRow(table.selectedRow)
    }
    
    @IBAction func duplicateClicked(_ sender: NSButton) {
        editRow(table.selectedRow, duplicate: true)
    }
    
    @objc func editClickedRow() {
        editRow(table.clickedRow)
    }
    
    @objc func duplicateClickedRow() {
        editRow(table.clickedRow, duplicate: true)
    }
    
    @objc func deleteClickedRow() {
        editRow(table.clickedRow)
    }
    
    func editRow(_ row: Int, duplicate: Bool = false) {
        
        if triggerStore.triggers.indices.contains(row) {
            sessionHandler.editTrigger(triggerStore.triggers[row], duplicateMode: duplicate)
        }
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        return triggerStore.triggers.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableColumn == descriptionColumn {
            
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TextCell"), owner: self) as! CNTextCell
            view.delegate = self
            view.label.stringValue = triggerStore.triggers[row].getDescriptionString()
            
            if HLLDefaults.notifications.enabled {
                view.label.textColor = .textColor
            } else {
                view.label.textColor = .disabledControlTextColor
            }
              
            return view
            
        }
        
        return nil
        
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        updateButtonsFromSelection()
    }
    
    func updateButtonsFromSelection() {
        
        let rows = table.selectedRowIndexes
        
        if rows.isEmpty {
        
        self.view.window?.makeFirstResponder(nil)
         setSelectionState(edit: false, remove: false)
            
        } else {
            
            if rows.count > 1 {
                 setSelectionState(edit: false, remove: true)
                
            } else {
                setSelectionState(edit: true, remove: true)
            }
            
        }
        
        if triggerStore.triggers.isEmpty {
            setSelectionState(edit: false, remove: false)
        }

        
    }
    
    @IBAction func removeClicked(_ sender: NSButton) {
        deleteSelectedTriggers()
    }
    
    override func keyDown(with event: NSEvent) {
        
        if event.charactersIgnoringModifiers == String(Character(UnicodeScalar(NSDeleteCharacter)!)) {
            deleteSelectedTriggers()
        }
        
    }
    
    func deleteSelectedTriggers() {
        
        for index in table.selectedRowIndexes {
            
            if triggerStore.triggers.indices.contains(index) {
                let trigger = triggerStore.triggers[index]
                triggerStore.deleteTrigger(trigger)
                
                
            }
        }
        
        update()
        
    }
    
    func setSelectionState(edit: Bool, remove: Bool) {
        
        editButton.isEnabled = edit
        duplicateButton.isEnabled = edit
        removeButton.isEnabled = remove
        
    }
    
    func generateRightClickMenu() -> NSMenu {
        
        let editMenuItem = NSMenuItem(title: "Edit", action: #selector(editClickedRow), keyEquivalent: "")
        let duplicateMenuItem = NSMenuItem(title: "Duplicate", action: #selector(duplicateClickedRow), keyEquivalent: "")
        let deleteMenuItem = NSMenuItem(title: "Delete", action: #selector(deleteClickedRow), keyEquivalent: "")
        
        let menu = NSMenu()
        menu.addItem(editMenuItem)
        menu.addItem(duplicateMenuItem)
        menu.addItem(deleteMenuItem)
        
        return menu
        
    }

    func setupOtherOptionButtons() {
        
        var soundState = NSControl.StateValue.off
        if HLLDefaults.notifications.sounds {
            soundState = .on
        }
        notificationSoundsButton.state = soundState
        
        var startState = NSControl.StateValue.off
        if HLLDefaults.notifications.startNotifications {
            startState = .on
        }
        eventStartTriggerButton.state = startState
        
        var endState = NSControl.StateValue.off
        if HLLDefaults.notifications.endNotifications {
            endState = .on
        }
        eventEndTriggerButton.state = endState
        
        hotKeyOffButton.state = .off
        hotkeyOptionWButton.state = .off
        hotKeyCommandTButton.state = .off
        
        switch HLLDefaults.notifications.hotkey {
        case .Off:
            hotKeyOffButton.state = .on
        case .OptionW:
            hotkeyOptionWButton.state = .on
        case .CommandT:
            hotKeyCommandTButton.state = .on
        }
        
    }
    
    @IBAction func startsClicked(_ sender: NSButton) {
        
        let on = sender.state == .on
        HLLDefaults.notifications.startNotifications = on
        MacEventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        
    }
    
    @IBAction func endsClicked(_ sender: NSButton) {
        
        let on = sender.state == .on
        HLLDefaults.notifications.endNotifications = on
        MacEventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        
    }
    
    @IBAction func hotKeyChangeClicked(_ sender: NSButton) {
        
        if sender == hotKeyOffButton {
            HLLDefaults.notifications.hotkey = .Off
        }
        
        if sender == hotkeyOptionWButton {
            HLLDefaults.notifications.hotkey = .OptionW
        }
        
        if sender == hotKeyCommandTButton {
            HLLDefaults.notifications.hotkey = .CommandT
        }
        
         HotKeyHandler.shared.setHotkey(to: HLLDefaults.notifications.hotkey)
        
    }
    
    @IBAction func soundsClicked(_ sender: NSButton) {
        
        let on = sender.state == .on
        HLLDefaults.notifications.sounds = on
        MacEventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        
    }
    
    
}

class TableResignDeselect: NSTableView {
    
    override func resignFirstResponder() -> Bool {
        self.deselectAll(nil)
        return true
    }
    
}
