//
//  EventsSettingsTableViewController.swift
//  iOS How Long Left
//
//  Created by Ryan Kontos on 25/9/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit

class EventsSettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "ToggleCell")
        self.navigationItem.title = "Events"
        self.navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HLLEventSource.shared.asyncUpdateEventPool()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleCell", for: indexPath) as! SwitchTableViewCell
        if indexPath.section == 0 {
            cell.label.text = "Show All-Day Events"
            cell.stateFetcher = { return HLLDefaults.general.showAllDay }
            cell.toggleAction = { HLLDefaults.general.showAllDay = $0 }
        }
        if indexPath.section == 1 {
            cell.label.text = "Combine Back To Back Events"
            cell.stateFetcher = { return HLLDefaults.general.combineDoubles }
            cell.toggleAction = { HLLDefaults.general.combineDoubles = $0 }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "Enabling this option will cause How Long Left to display back-to-back events with the same title as a single, combined event."
        }
        return nil
    }
    
}
