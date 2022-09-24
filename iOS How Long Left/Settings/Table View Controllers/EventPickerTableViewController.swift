//
//  EventPickerTableViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class EventPickerTableViewController: UITableViewController {

    var datesOfEvents = [DateOfEvents]()
    
    var eventSelectionHandler: ((HLLEvent?) -> ())?
    
    var excludeIDs = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(IconButtonTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        
        self.navigationItem.largeTitleDisplayMode = .never
        
        let cancelItem = UIBarButtonItem(systemItem: .cancel)
        cancelItem.target = self
        cancelItem.action = #selector(close)
        
        self.navigationItem.leftBarButtonItem = cancelItem
        
        datesOfEvents = HLLEventSource.shared.getAllEventsGroupedByDate(excludeIDs)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return datesOfEvents.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datesOfEvents[section].events.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datesOfEvents[section].date.userFriendlyRelativeString()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let event = datesOfEvents[indexPath.section].events[indexPath.row]
        
        var config = UIListContentConfiguration.subtitleCell()
        
        config.text = event.title
        config.secondaryText = "\(event.startDate.formattedDate()), \(event.startDate.formattedTime())"
        
        config.secondaryTextProperties.color = .secondaryLabel
        
        cell.contentConfiguration = config
        cell.selectionStyle = .default
        
        cell.accessoryType = .none

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let event = self.datesOfEvents[indexPath.section].events[indexPath.row]
        
        self.eventSelectionHandler?(event)
        
        close()
        
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

    @objc func close() {
        
        self.dismiss(animated: true)
        
    }
    
}
