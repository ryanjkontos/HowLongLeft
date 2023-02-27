//
//  CountdownTabOrderingTableViewController.swift
//  How Long Left
//
//  Created by Ryan Kontos on 24/2/2023.
//  Copyright © 2023 Ryan Kontos. All rights reserved.
//

import UIKit

class CountdownTabOrderingTableViewController: UITableViewController {

    var orderRows = [CountdownTabSection]()
    
    var showInProgress = false
    var showUpcoming = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //self.navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(done))
        
        orderRows = HLLDefaults.countdownsTab.sectionOrder
        
        self.isEditing = true
        
        update()
        updateOnStateChange()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        orderRows = HLLDefaults.countdownsTab.sectionOrder
    }
    
    @objc func done() {
        
        self.dismiss(animated: true)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return orderRows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var config = UIListContentConfiguration.cell()
        config.text = orderRows[indexPath.row].displayString
        textCell.contentConfiguration = config
    //    textCell.backgroundColor = HLLColors.groupedCell
        return textCell
    }
    
    func update() {
        
        
        if !orderRows.contains(.pinned) {
            orderRows.insert(.pinned, at: 0)
        }
        
        self.showInProgress = HLLDefaults.countdownsTab.showInProgress
        
        self.showUpcoming = HLLDefaults.countdownsTab.showUpcoming
        
        
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
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

       
            let item = orderRows[fromIndexPath.row]
            orderRows.removeAll(where: { $0 == item })
            orderRows.insert(item, at: to.row)
        
        
        HLLDefaults.countdownsTab.sectionOrder = orderRows
        
        DispatchQueue.main.async {
            EventChangeMonitor.shared.updateAppForChanges()
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
            return false
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }



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
