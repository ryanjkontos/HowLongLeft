//
//  WidgetConfigListTableViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 2/8/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class WidgetConfigListTableViewController: UITableViewController {

    let customCellID = "CustomCell"
    
    let store = WidgetConfigurationStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: customCellID)
        
        self.navigationItem.title = "Widget Configurations"
        self.navigationItem.largeTitleDisplayMode = .never
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        switch ListSection(rawValue: section)! {
            
        case .descriptionHeader:
            
            return 0
            
        case .defaultSection:
            return 1
        case .customSection:
            return store.customGroups.count+1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch ListSection(rawValue: section)! {
            
        case .descriptionHeader:
            
            return nil
            
        case .defaultSection:
            return nil
        case .customSection:
            return "Custom Configurations"
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch ListSection(rawValue: section)! {
            
        case .descriptionHeader:
            return "Create a widget configuration here, then apply it to a widget by long pressing it and selecting \"Edit Widget\"."
        case .defaultSection:
            return "This configuration will be applied to new widgets."
        case .customSection:
            return "Custom configurations can be created and applied to widgets."
        }
        
    }
        
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: self.customCellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        switch ListSection(rawValue: indexPath.section)! {
            
        case .descriptionHeader:
            break
        case .defaultSection:
            content.text = "Default Configuration"
            cell.accessoryType = .disclosureIndicator
        case .customSection:
            
            if store.customGroups.indices.contains(indexPath.row) {
                let item = store.customGroups[indexPath.row]
                content.text = item.name
                cell.accessoryType = .disclosureIndicator
            } else {
                content.text = "New Configuration"
                content.textProperties.color = .systemOrange
            }
            
        }
        
        cell.contentConfiguration = content
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UITableViewController(style: .insetGrouped)
        
        
      /*  switch ListSection(rawValue: indexPath.section)! {
            
        case .descriptionHeader:
            break
        case .defaultSection:
           // vc.configuration = store.defaultGroup
        
        case .customSection:
            
            if store.customGroups.indices.contains(indexPath.row) {
              //  vc.configuration = store.customGroups[indexPath.row]
            } else {
                return
            }
            
            
            
            
        } */
        
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    enum ListSection: Int, CaseIterable {
        case descriptionHeader
        case defaultSection
        case customSection
        
    }

}
