//
//  MagdaleneTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 19/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit
import Foundation

/*
class MagdaleneTableViewController: UITableViewController, SwitchCellDelegate, DefaultsTransferObserver {
    
    var sections = [MagdalenePreferencesSection]()
    
    override func viewDidLoad() {
        self.navigationItem.title = "Magdalene Mode"
        loadSections()
        HLLDefaultsTransfer.shared.addTransferObserver(self)
         tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        tableView.register(UINib(nibName: "TitleDetailCell", bundle: nil), forCellReuseIdentifier: "TitleDetailCell")
        
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if SchoolAnalyser.privSchoolMode != .Magdalene {
            self.navigationController?.popToRootViewController(animated: false)
        }
        
        loadSections()
        tableView.reloadData()
        
    }

    // MARK: - Table view data source

    func loadSections() {
        
        var sectionsArray = [MagdalenePreferencesSection]()
        
        sectionsArray.append(.Master)
        
        if SchoolAnalyser.schoolMode == .Magdalene {
            
            sectionsArray.append(.General)
            
            sectionsArray.append(.OldRoomNames)
            
            if let session = WatchSessionManager.sharedManager.validSession, session.isPaired {
                sectionsArray.append(.AppleWatch)
            }
            
            //sectionsArray.append(.Rename)
            
        }
       
        self.sections = sectionsArray
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return sections.count

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
            
        case .Master:
            return 1
        case .General:
            return 6
        case .AppleWatch:
            return 1
        case .OldRoomNames:
            return 3

        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let section = sections[indexPath.section]
        let row = indexPath.row
        
        switch section {
            
        case .Master:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.delegate = self
            cell.label = "Magdalene Mode"
            cell.cellIdentifier = "Main"
            cell.getAction = { return !HLLDefaults.magdalene.manuallyDisabled }
            cell.triggersDefaultsTransferOnToggle = false
            cell.setAction = { value in
                
                HLLDefaults.magdalene.manuallyDisabled = !value
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                
                
                    DispatchQueue.global(qos: .default).async {
                    
                        HLLDefaultsTransfer.shared.userModifiedPrferences()
                    }
                    
                    
                }
            
                DispatchQueue.global(qos: .default).async {
                HLLEventSource.shared.updateEventPool()
                }
            }
            
            return cell
            
        case .General:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.delegate = self
            
            if row == 0 {
                
                cell.label = "Show Subject Names"
                cell.getAction = { return HLLDefaults.magdalene.useSubjectNames }
                cell.setAction = { value in
                    HLLDefaults.magdalene.useSubjectNames = value
                    HLLEventSource.shared.asyncUpdateEventPool()
                }
                
                return cell
                
            }
            
            if row == 1 {
                           
                cell.label = "Indicate Timetable Changes"
                cell.getAction = { return HLLDefaults.magdalene.showChanges }
                cell.setAction = { value in
                    HLLDefaults.magdalene.showChanges = value
                    HLLEventSource.shared.asyncUpdateEventPool()
                           
                }
                
                return cell
                           
                }
            
            
            if row == 2 {
                
                cell.label = "Add Lunch, Recess & Sport"
                cell.getAction = { return HLLDefaults.magdalene.showBreaks }
                cell.setAction = { value in
                    HLLDefaults.magdalene.showBreaks = value
                    HLLEventSource.shared.asyncUpdateEventPool()
                }
                
                return cell
                
            }
            
            if row == 3 {
                
                cell.label = "Show Current Term"
                cell.getAction = { return HLLDefaults.magdalene.doTerm }
                cell.setAction = { value in
                    HLLDefaults.magdalene.doTerm = value
                    HLLEventSource.shared.asyncUpdateEventPool()
                }
                
                return cell
                
            }
            
            if row == 4 {
                
                cell.label = "Show School Holidays"
                cell.getAction = { return HLLDefaults.magdalene.doHolidays }
                cell.setAction = { value in
                    HLLDefaults.magdalene.doHolidays = value
                    HLLEventSource.shared.asyncUpdateEventPool()
                    
                }
                
                return cell
                
            }
                
                cell.label = "Show Sport as \"Study\""
                cell.getAction = { return HLLDefaults.magdalene.showSportAsStudy }
                cell.setAction = { value in
                    HLLDefaults.magdalene.showSportAsStudy = value
                    HLLEventSource.shared.asyncUpdateEventPool()
                
                
            }
            
            return cell
            
        case .AppleWatch:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.delegate = self
            
            cell.label = "Don't List Breaks and Homeroom"
            cell.getAction = { return HLLDefaults.magdalene.hideExtras }
            cell.setAction = { value in
                HLLDefaults.magdalene.hideExtras = value
            }
            
            return cell
            
        case .OldRoomNames:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! TitleDetailCell
                  
                  let type = OldRoomNamesSetting(rawValue: indexPath.row)!
                  
                  if HLLDefaults.magdalene.oldRoomNames == type {
                      cell.accessoryType = .checkmark
                  } else {
                      cell.accessoryType = .none
                  }
                  
                  var title: String
                  
                  switch type {

                  case .doNotShow:
                      title = "Don't Show"
                  case .showInSubmenu:
                      title = "Show In Event Info View"
                  case .replace:
                      title = "Show As Actual Location"
                  }
                  
                  cell.title = title
                  
                  return cell
            
        }
            
        
       
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath) as? TitleDetailCell {
            
            if let handler = cell.selectionHandler {
                handler()
                return
            }

        }
        
        let sectionType = sections[indexPath.section]
        
        if sectionType == .OldRoomNames {
            
            let type = OldRoomNamesSetting(rawValue: indexPath.row)!
            HLLDefaults.magdalene.oldRoomNames = type
            HLLDefaultsTransfer.shared.userModifiedPrferences()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            tableView.reloadData()
            }
            
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch sections[section] {
            
        case .Master:
            return "Enable features useful for Magdalene users, including subject name adjustments, bell-accurate countdown times, Lunch & Recess events, current Term/School Holidays countdown, and more."
        case .General:
            return nil
        case .AppleWatch:
            return nil
            
        case .OldRoomNames:

                switch HLLDefaults.magdalene.oldRoomNames {
                    
                case .doNotShow:
                    return "Old Room Names with not be shown anywhere."
                case .showInSubmenu:
                    return "Old Room Names will only be shown in Event Submenus. The New Names will be shown everywhere else."
                case .replace:
                    return "Rooms will be shown with the Old Room Names everywhere. New Names will be shown seperately in Event Submenus."
                    
                }

        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch sections[section] {
            
        case .Master:
            return nil
        case .General:
            return nil
        case .AppleWatch:
            return "Apple Watch Only"
            
        case .OldRoomNames:
            return "Old Room Names"
        }
        
    }

    func switchCellWasToggled(_ sender: SwitchCell) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
            
            self.loadSections()
            self.tableView.reloadData()
            
            HLLDefaultsTransfer.shared.userModifiedPrferences()
        })
        
       
        
    }
    
    func defaultsUpdated() {
        DispatchQueue.main.async {
            self.loadSections()
            self.tableView.reloadData()
        }
    }
    
}

enum MagdalenePreferencesSection {
    
    case Master
    case General
    case OldRoomNames
    case AppleWatch
    
}
*/
