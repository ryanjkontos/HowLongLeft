//  RNUIConfigurationViewController
//  RNUIConfigurationViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 21/6/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

/*
import Cocoa

class RNUIConfigurationViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    var parentController: ControllableTabView!
    
    @IBOutlet weak var RNUIAddBreaks: NSButton!
    
    let setup = RNDataStore()
    
    
    @IBAction func nextClicked(_ sender: NSButton) {
        
        parentController.nextPage()
        
    }
    
    @IBAction func backClicked(_ sender: NSButton) {
        
      parentController.previousPage()
        
    }
    
    
    var renameableEvents = [RNEvent]()
    var oldNames = [String]()
    let schoolAnalyser = SchoolAnalyser()
    
    @IBOutlet weak var table: NSTableView!
    
    override func viewDidLoad() {
        
        parentController = (self.parent as! ControllableTabView)
        
        if HLLDefaults.defaults.bool(forKey: "RNNoBreaks") == true {
            
            RNUIAddBreaks.state = .off
            
        } else {
            
            
            RNUIAddBreaks.state = .on
            
        }
        
        renameableEvents = setup.readFromDefaults()
        
        table.dataSource = self
        table.delegate = self
        
        
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        
        for item in renameableEvents {
            
            print("Renameable: \(item.oldName), \(item.newName), \(item.selected)")
            
        }
        
        
        return renameableEvents.count
        
        
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if tableColumn!.identifier.rawValue == "0" {
            
           let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CheckCell"), owner: nil) as! CheckCell
            
            if renameableEvents[row].selected == true {
                
                cell.checkBox.state = .on
                
            } else {
                
                cell.checkBox.state = .off
                
            }
            
            cell.setup(eventTitle: renameableEvents[row].oldName, store: self, enabled: renameableEvents[row].selected)
            
            return cell
            
        }
        
        if tableColumn!.identifier.rawValue == "1" {
            
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "TextCell"), owner: nil) as! TextCell
            
            cell.title.stringValue = renameableEvents[row].oldName
            
            cell.setup(eventTitle: renameableEvents[row].oldName, store: self, enabled: renameableEvents[row].selected)
            
            return cell
            
        }
        
        if tableColumn!.identifier.rawValue == "2" {
            
            let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "EditableTextCell"), owner: nil) as! EditableTextCell
            
            cell.title.stringValue = renameableEvents[row].newName
            
            cell.setup(eventTitle: renameableEvents[row].oldName, store: self, enabled: renameableEvents[row].selected)
            
            return cell
            
        }
        
        return nil
        
        
    }
    
    @IBAction func addBreaksClicked(_ sender: NSButton) {
        
        if sender.state == .off {
            
            HLLDefaults.defaults.set(true, forKey: "RNNoBreaks")
            
        } else {
            
            HLLDefaults.defaults.set(false, forKey: "RNNoBreaks")
            
            
        }
        
    }
    
    
}

extension RNUIConfigurationViewController: RenameablesStore {
    
    func setEnabledStatus(to: Bool, forEvent: String) {
        
        var dupeArray = [RNEvent]()
        
        for event in renameableEvents {
            
            let dupeEvent = event
            
            if event.oldName == forEvent {
                
                dupeEvent.selected = to
                
            }
            
            dupeArray.append(dupeEvent)
            
        }
        
        DispatchQueue.main.async {
            
            [unowned self] in
            
            self.renameableEvents = dupeArray
            self.setup.saveToDefaults(items: self.renameableEvents)
            self.renameableEvents = self.setup.readFromDefaults()
            self.table.reloadData()
        }
            
    }
    
    func setNewName(to: String, forEvent: String) {
        var dupeArray = [RNEvent]()
        
        for event in renameableEvents {
            
            let dupeEvent = event
            
            if event.oldName == forEvent {
                
                dupeEvent.newName = to
                
            }
            
            dupeArray.append(dupeEvent)
            
        }
        
        DispatchQueue.main.async {
            
            [unowned self] in
            
            self.renameableEvents = dupeArray
            self.setup.saveToDefaults(items: self.renameableEvents)
            self.renameableEvents = self.setup.readFromDefaults()
            self.table.reloadData()
        }
        
    }
    
}

class TextCell: NSTableCellView {
    
    var eventName: String!
    var delegate: RenameablesStore!
    var cellSelected: Bool!
    
    func setup(eventTitle: String, store: RenameablesStore, enabled: Bool) {
        
        eventName = eventTitle
        delegate = store
        cellSelected = enabled
        
        if cellSelected == true {
            
            title.textColor = .controlTextColor
            
        } else {
            
            title.textColor = .disabledControlTextColor
            
        }
        
    }
    
    @IBOutlet weak var title: NSTextField!
    
    
}

class EditableTextCell: NSTableCellView {
    
    var eventName: String!
    var delegate: RenameablesStore!
    var cellSelected: Bool!
    
    func setup(eventTitle: String, store: RenameablesStore, enabled: Bool) {
        
        eventName = eventTitle
        delegate = store
        cellSelected = enabled
        
        if cellSelected == true {
            
            title.textColor = .controlTextColor
            
        } else {
            
            title.textColor = .disabledControlTextColor
            
        }
        
    }
    
    
    @IBAction func textCellEdited(_ sender: NSTextField) {
        
        delegate.setNewName(to: sender.stringValue, forEvent: eventName)
        
    }
    
    @IBOutlet weak var title: NSTextFieldCell!
    
}

class CheckCell: NSTableCellView {
    
    var eventName: String!
    var delegate: RenameablesStore!
    var cellSelected: Bool!
    
    func setup(eventTitle: String, store: RenameablesStore, enabled: Bool) {
        
        
        eventName = eventTitle
        delegate = store
        cellSelected = enabled
        
        
    }
    
    @IBAction func checkClicked(_ sender: NSButton) {
        
        if sender.state == .on {
            
         delegate.setEnabledStatus(to: true, forEvent: eventName)
            
        } else {
            
            delegate.setEnabledStatus(to: false, forEvent: eventName)
            
            
        }
        
        
        
    }
    
    
    @IBOutlet weak var checkBox: NSButton!
    
}

protocol RenameablesStore {
    
    func setEnabledStatus(to: Bool, forEvent: String)
    func setNewName(to: String, forEvent: String)
    
}
*/
