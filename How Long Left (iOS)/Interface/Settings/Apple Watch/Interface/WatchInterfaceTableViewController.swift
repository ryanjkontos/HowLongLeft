//
//  WatchInterfaceTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 24/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class WatchInterfaceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Interface"
        
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return 1
        }
        
        if section == 2 {
            
            if HLLDefaults.watch.showUpcoming {
                return 2
            } else {
                return 1
            }

        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

        if indexPath.section == 0 {
            
            switchCell.cellLabel.text = "Large Countdown"
            switchCell.getAction = { return HLLDefaults.watch.largeCell }
            switchCell.setAction = { HLLDefaults.watch.largeCell = $0 }
            
        }
        
        if indexPath.section == 1 {
            
            switchCell.cellLabel.text = "Show One Event Only"
            switchCell.getAction = { return HLLDefaults.watch.showOneEvent }
            switchCell.setAction = { HLLDefaults.watch.showOneEvent = $0 }
            
        }
        
        if indexPath.section == 2 {
            
            if indexPath.row == 0 {
            
            switchCell.cellLabel.text = "Show Upcoming Events"
            switchCell.getAction = { return HLLDefaults.watch.showUpcoming }
            switchCell.setAction = { value in
                
                HLLDefaults.watch.showUpcoming = value
                
                let path = IndexPath(row: 1, section: 2)
                
                if value == false {
                    tableView.deleteRows(at: [path], with: .top)
                } else {
                    tableView.insertRows(at: [path], with: .top)
                }
                
            }
                
            }
            
            if indexPath.row == 1 {
                
                switchCell.cellLabel.text = "Show Current Events First"
                switchCell.getAction = { return HLLDefaults.watch.showCurrentFirst }
                switchCell.setAction = { HLLDefaults.watch.showCurrentFirst = $0 }
                
            }
            
        }

        return switchCell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if section == 0 {
            
            return "Show a large countdown at the top of the events table."
            
        }
        
        if section == 1 {
            
            return "Show only the top event instead of a list of events."
            
        }
        
        if section == 2 {
            
            return "List current events above all upcoming events, instead of in chronological order."
            
        }
        
        return nil
        
    }
 

}
