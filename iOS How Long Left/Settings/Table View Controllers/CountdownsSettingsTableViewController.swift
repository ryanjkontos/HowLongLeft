//
//  CountdownsSettingsTableViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
import SwiftUI

class CountdownsSettingsTableViewController: HLLAppearenceTableViewController {

    enum Section {
        case inProgress
        case upcoming
        case ordering
        case offset
    }

    
    var showInProgress = false
    var showEndingTodayOnly = false
    
    var showUpcoming = false
    
    var sections = [Section]()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Countdowns"
        
        
       // self.tableView.backgroundColor = HLLColors.backgroundColor
        //self.isEditing = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(StepperTableViewCell.self, forCellReuseIdentifier: "StepperCell")
        
        
        
        update()
        
        
        
    }
    
    func update() {
        sections = [.inProgress, .upcoming]
        self.showEndingTodayOnly = HLLDefaults.countdownsTab.onlyEndingToday
        self.showInProgress = HLLDefaults.countdownsTab.showInProgress
        
        self.showUpcoming = HLLDefaults.countdownsTab.showUpcoming
        
        if (showInProgress || showUpcoming) {
            sections.append(.ordering)
        }
        
        sections.append(.offset)
        
    }
    
    func updateOnStateChange() {
        
        DispatchQueue.main.async {
            EventChangeMonitor.shared.updateAppForChanges()
        }
           
            let oldSections = self.sections
            let oldInProgress = self.showInProgress
            let oldUpcoming = self.showUpcoming
            
            self.update()
            
            
            self.tableView.performBatchUpdates({
                
                if self.showInProgress == false, oldInProgress == true {
                    self.tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                }
                if self.showInProgress == true, oldInProgress == false {
                    self.tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
                }
                
                if self.showUpcoming == false, oldUpcoming == true {
                    self.tableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
                }
                if self.showUpcoming == true, oldUpcoming == false {
                    self.tableView.insertRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
                }
                
                if oldSections.count != self.sections.count {
                
                    if !self.sections.contains(.ordering) && oldSections.contains(.ordering) {
                        self.tableView.deleteSections(IndexSet(integer: 2), with: .fade)
                    }
                    
                    if self.sections.contains(.ordering) && !oldSections.contains(.ordering) {
                        self.tableView.insertSections(IndexSet(integer: 2), with: .fade)
                    }
                
                }
                
             
                
            })
            
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = sections[section]
        
        switch section {
            
        case .inProgress:
            
            return showInProgress ? 2 : 1
            
        case .upcoming:
            return showUpcoming ? 2 : 1
        case .ordering:
            return 1
        case .offset:
            return 1
        }
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! SwitchTableViewCell
       // cell.backgroundColor = HLLColors.groupedCell
        
        let section = sections[indexPath.section]
        
        switch section {
            
        case .inProgress:
            
            if indexPath.row == 0 {
                cell.label.text = "Show In-Progress Events"
                cell.stateFetcher = { return HLLDefaults.countdownsTab.showInProgress }
                cell.toggleAction = { HLLDefaults.countdownsTab.showInProgress = $0; self.updateOnStateChange() }
            } else {
                cell.label.text = "Ending Today Only"
                cell.stateFetcher = { return HLLDefaults.countdownsTab.onlyEndingToday }
                cell.toggleAction = { HLLDefaults.countdownsTab.onlyEndingToday = $0; self.updateOnStateChange() }
            }
            
        case .upcoming:
            if indexPath.row == 0 {
                cell.label.text = "Show Upcoming Events"
                cell.stateFetcher = { return HLLDefaults.countdownsTab.showUpcoming }
                cell.toggleAction = { HLLDefaults.countdownsTab.showUpcoming = $0; self.updateOnStateChange() }
            } else {
                let stepperCell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as! StepperTableViewCell
                stepperCell.label.text = "1 Upcoming Event"
                stepperCell.stepper.value = Double(HLLDefaults.countdownsTab.upcomingCount)
                stepperCell.updateAction = { value in
                    HLLDefaults.countdownsTab.upcomingCount = value
                    
                    DispatchQueue.main.async {
                        EventChangeMonitor.shared.updateAppForChanges()
                    }
                    
                }
                stepperCell.labelUpdator = {
                    
                    let count = HLLDefaults.countdownsTab.upcomingCount
                    return "\(count) Upcoming Event\(count == 1 ? "" : "s")"
                }
                stepperCell.stepper.minimumValue = 1
                stepperCell.stepper.maximumValue = 25
                
              //  stepperCell.backgroundColor = HLLColors.groupedCell
                return stepperCell
            }
        case .ordering:
            
            let textCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = UIListContentConfiguration.cell()
            config.text = "Section Order"
            textCell.contentConfiguration = config
            textCell.accessoryType = .disclosureIndicator
        //    textCell.backgroundColor = HLLColors.groupedCell
            return textCell
        case .offset:
            
            let textCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = UIListContentConfiguration.cell()
            config.text = "Shift Countdown Times"
            textCell.contentConfiguration = config
            textCell.accessoryType = .disclosureIndicator
            return textCell
        }
       
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let section = sections[section]
        switch section {
            
        case .inProgress:
            return "In-Progress"
        case .upcoming:
            return "Upcoming"
        case .ordering:
            return "Ordering"
        case .offset:
            return nil
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let section = sections[section]
        
        if section == .offset {
            return "Shift event countdowns from their actual date by a few seconds."
        }
        
        return nil
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if sections[indexPath.section] == .ordering {
            self.navigationController?.pushViewController(CountdownTabOrderingTableViewController(style: .insetGrouped), animated: true)
        }
        
        if sections[indexPath.section] == .offset {
            
            let controller = UIHostingController(rootView: EventDateOffsetSettingsView())
            controller.navigationItem.largeTitleDisplayMode = .never
            controller.title = "Calendar Offsets"
            controller.loadViewIfNeeded()
            controller.loadView()
            controller.viewWillAppear(false)
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    */
    

    
    // Override to support rearranging the table view.


    
    // Override to support conditional rearranging of the table view.
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}
