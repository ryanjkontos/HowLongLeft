//
//  DebugMenuTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 27/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class DebugMenuTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Debug"
        tableView.register(UINib(nibName: "TitleDetailCell", bundle: nil), forCellReuseIdentifier: "TitleDetailCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 3 {
            return 2
        } else {
            return 1
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell", for: indexPath) as! TitleDetailCell

        if indexPath.section == 0 {
            
            cell.title = "Send Test Notification"
            cell.selectionHandler = { EventNotificationScheduler.shared.sendTestNoto()
               
                
            }
            
        }
        
        if indexPath.section == 1 {
            
            cell.title = "BGTask Counter"
            cell.detail = "\(HLLDefaults.defaults.integer(forKey: "BGCount"))"
            cell.selectionStyle = .none
            // Configure the cell...
            
        }
        
        if indexPath.section == 2 {
            
            cell.title = "Launched From Widget"
            
            cell.detail = String(HLLDefaults.defaults.integer(forKey: "LFW"))
            
            cell.selectionStyle = .none
            // Configure the cell...
            
        }
        
        if indexPath.section == 3 {
            
            let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            
            if indexPath.row == 0 {
            
                switchCell.cellLabel.text = "Override Purchased Status"
                switchCell.getAction = { return HLLDefaults.complication.overrideComplicationPurchased }
                switchCell.setAction = { value in
                    HLLDefaults.complication.overrideComplicationPurchased = value
                }
                
                switchCell.selectionStyle = .none
                
            }
            
            if indexPath.row == 1 {
                
                switchCell.cellLabel.text = "Overriden Status"
                switchCell.getAction = { return HLLDefaults.complication.overridenComplicationPurchasedStatus }
                switchCell.setAction = { value in
                    HLLDefaults.complication.overridenComplicationPurchasedStatus = value
                }
                    
                switchCell.selectionStyle = .none
                
            }
            
            return switchCell
        }
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Notifications"
        }
        
        if section == 1 {
            return "Background Tasks"
        }
        
        if section == 3 {
            return "Complication"
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let row = tableView.cellForRow(at: indexPath) as? TitleDetailCell {
            
            row.selectionHandler?()
            
        }
        
    }

}
