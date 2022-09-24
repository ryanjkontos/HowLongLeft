//
//  CountdownsSettingsTableViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 24/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class CountdownsSettingsTableViewController: UITableViewController {

    enum Section {
        case inProgress
        case upcoming
        case ordering
    }

    
    var showInProgress = false
    var showEndingTodayOnly = false
    
    var showUpcoming = false
    
    var sections = [Section]()
    
    var orderRows = [CountdownTabSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "Countdowns"
        
        self.isEditing = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(StepperTableViewCell.self, forCellReuseIdentifier: "StepperCell")
        
        orderRows = HLLDefaults.countdownsTab.sectionOrder
        
        update()
        
        
        
    }
    
    func update() {
        sections = [.inProgress, .upcoming]
        self.showInProgress = HLLDefaults.countdownsTab.showInProgress
        self.showEndingTodayOnly = HLLDefaults.countdownsTab.onlyEndingToday
        self.showUpcoming = HLLDefaults.countdownsTab.showUpcoming
        
        if (showInProgress || showUpcoming) {
            sections.append(.ordering)
        }
        
       
        
        if !orderRows.contains(.pinned) {
            orderRows.insert(.pinned, at: 0)
        }
        
        
        if showInProgress {
            if !orderRows.contains(.inProgress) { orderRows.append(.inProgress) }
        } else {
            if orderRows.contains(.inProgress) { orderRows.removeAll(where: { $0 == .inProgress }) }
        }
        

        if showUpcoming {
            if !orderRows.contains(.upcoming) { orderRows.append(.upcoming) }
        } else {
            if orderRows.contains(.upcoming) { orderRows.removeAll(where: { $0 == .upcoming }) }
        }
        
    }
    
    func updateOnStateChange() {
        
            
            let oldRows = self.orderRows
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
                
                if self.sections.count == 3 {
                    
                    if oldRows.contains(.inProgress), !showInProgress {
                        self.tableView.deleteRows(at: [IndexPath(row: oldRows.firstIndex(of: .inProgress)!, section: 2)], with: .automatic)
                    }
                    
                    if !oldRows.contains(.inProgress), showInProgress {
                        self.tableView.insertRows(at: [IndexPath(row: orderRows.firstIndex(of: .inProgress)!, section: 2)], with: .automatic)
                    }
                    
                    if oldRows.contains(.upcoming), !showUpcoming {
                        self.tableView.deleteRows(at: [IndexPath(row: oldRows.firstIndex(of: .upcoming)!, section: 2)], with: .automatic)
                    }
                    
                    if !oldRows.contains(.upcoming), showUpcoming {
                        self.tableView.insertRows(at: [IndexPath(row: orderRows.firstIndex(of: .upcoming)!, section: 2)], with: .automatic)
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
            return orderRows.count
            
        }
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! SwitchTableViewCell

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
                }
                stepperCell.labelUpdator = {
                    
                    let count = HLLDefaults.countdownsTab.upcomingCount
                    return "\(count) Upcoming Event\(count == 1 ? "" : "s")"
                }
                stepperCell.stepper.minimumValue = 1
                stepperCell.stepper.maximumValue = 25
                
                
                return stepperCell
            }
        case .ordering:
            
            let textCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var config = UIListContentConfiguration.cell()
            config.text = orderRows[indexPath.row].displayString
            textCell.contentConfiguration = config
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
        }
        
    }


   
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return indexPath.section == 2
    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    */
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

        if fromIndexPath.section == 2 && to.section == 2 {
            let item = orderRows[fromIndexPath.row]
            orderRows.removeAll(where: { $0 == item })
            orderRows.insert(item, at: to.row)
        }
        
        HLLDefaults.countdownsTab.sectionOrder = orderRows
        
    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return indexPath.section == 2
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return IndexPath(row: row, section: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }

}
