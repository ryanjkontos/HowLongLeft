//
//  ToggleCalendarsTableViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 28/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class ToggleCalendarsTableViewController: HLLAppearenceTableViewController {

    let manager = AppEnabledCalendarsManager.shared
    
    var cals = [IdentifiableCalendar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoCell")
        
        self.navigationItem.title = "Calendars"
        
        tableView.allowsSelection = false
        
        self.navigationItem.largeTitleDisplayMode = .never
        updateToggleAllButton()
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cals = manager.allCalendars
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? cals.count : 1
        
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! SwitchTableViewCell
      //  cell.backgroundColor = HLLColors.groupedCell
        if indexPath.section == 0 {
        
           
            cell.showIndicator = true
            let cal = cals[indexPath.row]
            cell.label.text = cal.calendar.title
            cell.indicator.backgroundColor = cal.calendar.getColor()
            cell.stateFetcher = { return cal.enabled }
            cell.toggleAction = {
                cal.enabled = $0
                self.updateToggleAllButton()
                
                HLLEventSource.shared.updateEventsAsync(bypassCollation: true)
            }
        
            
        
        } else {
            
            cell.showIndicator = false
            cell.label.text = "Use New Calendars"
            
            cell.stateFetcher = { return HLLDefaults.calendar.useNewCalendars }
            cell.toggleAction = {
                HLLDefaults.calendar.useNewCalendars = $0
                HLLEventSource.shared.updateEventsAsync()
            }
            
        }
        
        return cell
       
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ?
        
        "Enabled Calendars" :
        nil
    }
    
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return section == 0 ?
        "Events from enabled calendars will appear in How Long Left" :
        "Enable new calendars automatically"
    }
    
    func updateToggleAllButton() {
        
        let removeAllButton = UIBarButtonItem(title: "Enable All", style: .plain, target: self, action: #selector(toggleAll))
        
        if manager.allEnabled {
            removeAllButton.title = "Disable All"
        }
        
        self.navigationItem.rightBarButtonItem = removeAllButton
        
    }
    
    @objc func toggleAll() {
        
        manager.toggleAll()
        
        for cell in tableView.visibleCells {
            
            guard let cell = cell as? SwitchTableViewCell else { continue }
            cell.updateToggleState(true)
            
        }
        
        updateToggleAllButton()
        
    }

}
