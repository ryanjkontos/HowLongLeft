//
//  WidgetConfigurationEditorTableViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 1/8/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
/*
class WidgetConfigurationEditorTableViewController: FormViewController {

    var configuration: HLLTimelineConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationItem.title = "Configuration"
        self.navigationItem.largeTitleDisplayMode = .never
        
        self.tableView.tintColor = .systemBlue
        
        if configuration.groupType == .defaultGroup {
            form.append(Section(header: nil, footer: "This is the default configuration"))
        } else {
            form.append(Section("Configuration Name")
                        <<< TextRow("nameRow") {
                            $0.placeholder = "Name"
                            
                        })
        }
        
        
         form   +++ Section("Event Status")
                <<< SwitchRow("inProgressRow"){
                    $0.title = "Show In Progress Events"
                    $0.value = configuration.showCurrent
                }
                <<< SwitchRow("upcomingRow"){
                    $0.title = "Show Upcoming Events"
                    $0.value = configuration.showUpcoming
                }
                <<< ActionSheetRow<String>("preferRow"){
                    $0.title = "Prefer"
                    $0.selectorTitle = "Determines how the widget chooses which event to display when multiple are avaliable"
                    $0.options = TimelineSortMode.allCases.map({$0.name})
                    $0.value = TimelineSortMode.chronological.name
                    $0.hidden = Condition.function(["inProgressRow", "upcomingRow"], { form in
                       return !((form.rowBy(tag: "inProgressRow") as! SwitchRow).value ?? false) || !((form.rowBy(tag: "upcomingRow") as! SwitchRow).value ?? false)
                    })
                    $0.cellUpdate({ cell, other in
                        cell.accessoryType = .disclosureIndicator
                        
                    })
                    
                    $0.onChange({
                        
                        // print("New value is \($0.value!)")
                        
                    })
                    
                }
        
                +++ Section("Calendars")
                <<< SwitchRow("allCalsRow"){
                    $0.title = "Use All Calendars"
                    $0.value = configuration.useAllCalendars
                }
            
                +++ Section()
                    <<< SwitchRow(){
                        $0.title = "Use All Calendars"
                        $0.value = configuration.useAllCalendars
                    }
               
            
      
        
     
        
    }



}*/
