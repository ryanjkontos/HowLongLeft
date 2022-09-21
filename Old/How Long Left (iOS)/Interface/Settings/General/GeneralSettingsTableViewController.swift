//
//  GeneralSettingsTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 21/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class GeneralSettingsTableViewController: UITableViewController {

    var allDayInCurrentCell: SwitchCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        HLLDefaultsTransfer.shared.addTransferObserver(self)
        self.navigationItem.title = "General"
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 1
        } else {
            return 1
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
        
        if indexPath.section == 0 {
            
            switchCell.label = "Show Event Locations"
            switchCell.getAction = { return HLLDefaults.general.showLocation }

            switchCell.setAction = { value in
                
                HLLDefaults.general.showLocation = value
                
            }
            
        }
        
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                switchCell.label = "Show All-Day Events"
                switchCell.getAction = { return HLLDefaults.general.showAllDay }

                switchCell.setAction = { value in
                    
                    HLLDefaults.general.showAllDay = value
                    
                    self.allDayInCurrentCell?.valueSwitch.isEnabled = value
                    
                    if value {
                        
                        if #available(iOS 13.0, *) {
                            self.allDayInCurrentCell?.cellLabel.textColor = .label
                        } else {
                            self.allDayInCurrentCell?.cellLabel.textColor = .white
                        }
                        
                    } else {
                        
                        if #available(iOS 13.0, *) {
                            self.allDayInCurrentCell?.cellLabel.textColor = .secondaryLabel
                        } else {
                            self.allDayInCurrentCell?.cellLabel.textColor = .lightGray
                        }
                        
                    }
                }
                
                
                
            }
            
            if indexPath.row == 1 {
                
                switchCell.label = "Include in Current Events"
                switchCell.getAction = { return HLLDefaults.general.showAllDayAsCurrent }

                switchCell.setAction = { value in
                    
                    HLLDefaults.general.showAllDayAsCurrent = value
                    
                }
                
                allDayInCurrentCell = switchCell
                
            }

                
        }
        
        if indexPath.section == 2 {
        
        switchCell.label = "Show Percentage Labels"
        switchCell.getAction = { return HLLDefaults.currentEventView.showPercentageLabels }

        switchCell.setAction = { value in
            
            HLLDefaults.currentEventView.showPercentageLabels = value
            
            
        }
      
            
        }
        
        if indexPath.section == 3 {

        switchCell.label = "Show Following Occurences"
        switchCell.getAction = { return HLLDefaults.general.showNextOccurItems }

        switchCell.setAction = { value in
            HLLDefaults.general.showNextOccurItems = value
        }
              
        }
        
        
        return switchCell
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return "Locations"
        }
        
        if section == 1 {
            return "All-Day Events"
        }
        
        if section == 2 {
            return "Current Event View"
        }
        
        if section == 3 {
            return "Event Info View"
        }
        
        return nil
        
    }
    


}

extension GeneralSettingsTableViewController: DefaultsTransferObserver {
    
    func defaultsUpdated() {
        
        DispatchQueue.main.async {
        
        for cell in self.tableView.visibleCells {
            
            if let switchCell = cell as? SwitchCell {
                
                switchCell.update()
                
            }
            
        }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                
                self.tableView.reloadData()
                
            })
            
        }
        
    }
    
}
