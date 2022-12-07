//
//  SettingsCalendarSelectTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 24/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit
import EventKit


class CalendarSelectTableViewController: UITableViewController, DefaultsTransferObserver, EventSourceUpdateObserver {

    var allCalendars = [EKCalendar]()
    var enabledCalendars = [EKCalendar]()
    
    var selectAllState = true

    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.tabBar.isHidden = true
        setupData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        
        self.navigationItem.title = "Calendars"
      //  HLLDefaultsTransfer.shared.addTransferObserver(self)
        HLLEventSource.shared.addeventsObserver(self)
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupData()
        
        self.clearsSelectionOnViewWillAppear = false
    }
    
   
  
    func setupData() {
        
        // print("Loading table")
        allCalendars = HLLEventSource.shared.getCalendars().sorted { $0.title.lowercased() < $1.title.lowercased() }

        setupSelectAllButton()
        tableView.reloadData()
        
        // print("PoolC7")
        
    }
    
    func setupSelectAllButton() {
        
        if CalendarDefaultsModifier.shared.allCalendarsEnabled() {
            
            self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Deselect all", style: .plain, target: self, action: #selector (selectAllButtonTapped)), animated: true)
            selectAllState = false
            
        } else {
            
            self.navigationItem.setRightBarButton(UIBarButtonItem(title: "Select all", style: .plain, target: self, action: #selector (selectAllButtonTapped)), animated: true)
            selectAllState = true
            
        }
        
    }
    
    @objc func selectAllButtonTapped() {
        
        DispatchQueue.main.async {
        
            if #available(iOS 10.0, *) {
                let lightImpactFeedbackGenerator = UISelectionFeedbackGenerator()
                lightImpactFeedbackGenerator.prepare()
                lightImpactFeedbackGenerator.selectionChanged()
            }
        
            
            CalendarDefaultsModifier.shared.toggleAllCalendars()
            
            self.setupSelectAllButton()
            self.updateToggles()
            
            
         //   HLLDefaultsTransfer.shared.userModifiedPrferences()
            
        }
        
    }
    
    func updateToggles() {
        
        for cell in self.tableView.visibleCells {
            
            if let calendarItemCell = cell as? SettingsCalendarItemCell {
                calendarItemCell.updateToggle()
            }
            
            if let switchCell = cell as? SwitchCell {
                switchCell.update()
            }
            
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return allCalendars.count
        } else {
            return 1
        }
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
           return "Select Calendars to use"
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 1 {
            return "Automatically enable new calendars as they are created."
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
        
        let calendarItem = allCalendars[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarItemCell", for: indexPath) as! SettingsCalendarItemCell
        cell.setCalendarItem(Calendar: calendarItem, delegate: self)
        cell.selectionStyle = .none
           
        return cell
            
        } else {
            
            tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            
            cell.label = "Use New Calendars"
            cell.getAction = { return HLLDefaults.calendar.useNewCalendars }
            cell.setAction = { value in
                
                HLLDefaults.calendar.useNewCalendars = value
                DispatchQueue.global(qos: .default).async {
                    HLLEventSource.shared.updateEvents()
                }
            
            }
            
            return cell
            
        }

    }
    
    func defaultsUpdated() {
        DispatchQueue.main.async {
            self.setupSelectAllButton()
            self.updateToggles()
        }
    }
    
    func eventsUpdated() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
           // self.setupData()
        }
    }
    
 
}
