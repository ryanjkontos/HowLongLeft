//
//  SiriAndWidgetTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 14/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

class SiriAndWidgetTableViewController: UITableViewController, ShortcutDelegate {
    
    var sections = [SiriAndWidgetSections]()
    
    override func viewDidLoad() {
        
        sections.append(.EditShortcut)
        sections.append(.ShowUpcoming)
        
        self.navigationItem.title = "Siri & Widget"
        super.viewDidLoad()
        VoiceShortcutStatusChecker.shared.delegate = self
        VoiceShortcutStatusChecker.shared.check()
        tableView.register(UINib(nibName: "TitleDetailCell", bundle: nil), forCellReuseIdentifier: "TitleDetailCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = sections[section]
        
        switch sectionType {
            
        case .EditShortcut:
            return 1
        case .ShowUpcoming:
            return 1
            
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = sections[indexPath.section]
        
        switch sectionType {
            
        case .EditShortcut:
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell", for: indexPath) as! TitleDetailCell

            cell.title = "Siri Shortcut"
            cell.detail = VoiceShortcutStatusChecker.shared.statusString
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        case .ShowUpcoming:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

            cell.label = "Show Upcoming Events"
            
            cell.getAction = {
                
                return HLLDefaults.appExtensions.showUpcoming
                
            }
            
            cell.setAction = { value in
                
                HLLDefaults.appExtensions.showUpcoming = value
            }
            
            return cell
            

        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let view = VoiceShortcutStatusChecker.shared.shortcutViewController {
            DispatchQueue.main.async {
                self.present(view, animated: true, completion: nil)
            }
        }
        
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        switch sections[section] {
            
        case .EditShortcut:

            if let phrase = VoiceShortcutStatusChecker.shared.phrase {
                return "Check How Long Left with Siri by saying \"\(phrase)\"."
            } else {
                return "Check How Long Left with Siri."
            }
            
        case .ShowUpcoming:
            return "When there are no current events, show the next event to start in Siri and the widget."
            
        }
        
        
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
    
    func shortcutUpdated() {
        tableView.reloadData()
    }

}

protocol ShortcutDelegate {
    
    func shortcutUpdated()
    
}

enum SiriAndWidgetSections {
    
    case EditShortcut
    case ShowUpcoming
    
}
