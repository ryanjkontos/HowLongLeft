//
//  ToggleCalendarsTableViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 28/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class ToggleCalendarsTableViewController: UITableViewController {

    let manager = AppEnabledCalendarsManager.shared
    
    var cals = [IdentifiableCalendar]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "InfoCell")
        
        self.navigationItem.title = "Calendars"
        
        tableView.allowsSelection = false
        
        self.navigationItem.largeTitleDisplayMode = .never
        

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        
        if indexPath.section == 0 {
        
           
            cell.showIndicator = true
            let cal = cals[indexPath.row]
            cell.label.text = cal.calendar.title
            cell.indicator.backgroundColor = cal.calendar.getColor()
            cell.stateFetcher = { return cal.calendar.isToggled }
            cell.toggleAction = { cal.enabled = $0 }
        
            
        
        } else {
            
            cell.showIndicator = false
            cell.label.text = "Use New Calendars"
            
            
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
        
        //let button = UIBarButtonItem(
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
