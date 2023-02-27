//
//  ManageEventsTableViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 23/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class ManageEventsTableViewController: HLLAppearenceTableViewController {

    var events = [HLLStoredEvent]()
    
    var dataSource: ManageEventsListDataSource
    
    init(dataSource: ManageEventsListDataSource) {
        self.dataSource = dataSource
        super.init(style: .insetGrouped)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.title = "\(dataSource.addedWord) Events"
        
        update()
        
        let removeAllButton = UIBarButtonItem(title: "\(dataSource.removeActionWord) All", style: .plain, target: self, action: #selector(removeAllEvents))
        self.navigationItem.rightBarButtonItem = removeAllButton
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func update() {
        
        events = dataSource.getAddedEvents()

        self.navigationItem.rightBarButtonItem?.isEnabled = !events.isEmpty
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count+1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        //cell.backgroundColor = HLLColors.groupedCell
        
        if indexPath.row != 0 {
            
            let event = events[indexPath.row-1]
            
            var config = UIListContentConfiguration.subtitleCell()
            
            config.text = event.title
            
            if let date = event.startDate {
                config.secondaryText = "\(date.formattedDate()), \(date.formattedTime())"
            }
           
            config.secondaryTextProperties.color = .secondaryLabel
            
            cell.contentConfiguration = config

            
            
        } else {
            
            
            var config = UIListContentConfiguration.cell()
            config.text = "Choose Event"
            config.textProperties.color = .systemOrange
            
            cell.contentConfiguration = config
            
            
            
        }
        
       

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(dataSource.addedWord) Events"
    }
    
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return dataSource.addedDescription
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            let pickerView = EventPickerTableViewController(style: .insetGrouped)
            
            pickerView.excludeIDs = self.events.compactMap({$0.identifier})
            
            pickerView.eventSelectionHandler = { event in
           
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    
                    guard let event = event else { return }
                    // print("Picker got \(event.title)")
                    self.dataSource.addAction(event: event)
                    self.update()
                    
                    self.tableView.insertRows(at: [IndexPath(row: self.events.count, section: 0)], with: .automatic)
                    
                }
                
               
            }
            
            self.present(HLLNavigationController(rootViewController: pickerView), animated: true)
            pickerView.navigationItem.title = "\(self.dataSource.addActionWord) Event"
            
        } else {
            
            let event = events[indexPath.row-1]
            presentDeleteAlert(for: event)
            
        }
        
       
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "\(dataSource.removeActionWord)", handler: {_,_,_ in
            self.unhide(events: [self.events[indexPath.row-1]])
        })
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
    func presentDeleteAlert(for event: HLLStoredEvent) {

        let alert = UIAlertController(title: "\(dataSource.removeActionWord) \(event.title!)?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "\(dataSource.removeActionWord)", style: .default) { _ in
            
            self.unhide(events: [event])
        })
        self.present(alert, animated: true)
    }
    
    func unhide(events eventsToUnhide: [HLLStoredEvent]) {
        
        let indexPaths = eventsToUnhide.map({ IndexPath(row: self.events.firstIndex(of: $0)!+1, section: 0) })
        dataSource.removeAction(events: eventsToUnhide)
        update()
        
        self.tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    @objc func removeAllEvents() {
        
        unhide(events: self.events)
        
    }

}
