//
//  HLLSettingsTableViewController.swift
//  How Long Left iOS App
//
//  Created by Ryan Kontos on 28/7/2022.
//  Copyright © 2022 Ryan Kontos. All rights reserved.
//

import UIKit
import SwiftUI

class HLLSettingsTableViewController: UITableViewController {

    typealias SettingsRow = IconButtonTableViewCell.Configuration
    
    
    
    var sections = [SettingsSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(IconButtonTableViewCell.self, forCellReuseIdentifier: "IconButtonCell")
            
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Settings"
        
        
        self.clearsSelectionOnViewWillAppear = false

        let mainSection = [
            RowType.countdowns,
            RowType.events,
            RowType.calendars
        ]
        
        let extensionsSection = [
            RowType.widget,
            RowType.complication,
            RowType.siri
        ]
        
        let debugSection = [
            RowType.debug
        ]
        
        sections = [SettingsSection(mainSection), SettingsSection(header: "Extensions", extensionsSection), SettingsSection(debugSection)]
        
    
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return sections[section].rows.count
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconButtonCell", for: indexPath) as! IconButtonTableViewCell
        cell.configure(using: sections[indexPath.section].rows[indexPath.row].asCellConfig())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let type = sections[indexPath.section].rows[indexPath.row]
            
        switch type {
            
        case .countdowns:
            break
        case .events:
            break
        case .calendars:
            
            let vc = ToggleCalendarsTableViewController(style: .insetGrouped)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .widget:
            
            let hc = UIHostingController(rootView: ExtensionPurchaseView(type: .widget, presentSheet: .constant(true)))
            self.present(hc, animated: true)
            
        case .complication:
            
            let hc = UIHostingController(rootView: ExtensionPurchaseView(type: .complication, presentSheet: .constant(true)))
            self.present(hc, animated: true)
            
        case .siri:
            break
        case .debug:
            break
        }
       
        
    
        
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
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

    struct SettingsSection {
        
        internal init(header: String? = nil, _ rows: [HLLSettingsTableViewController.RowType] = [RowType]()) {
            self.header = header
            self.rows = rows
        }
        
        
        var header: String?
        var rows = [RowType]()
        
    }
    
    enum RowType: CaseIterable {
        
        case countdowns
        case events
        case calendars
        
        case widget
        case complication
        case siri
        
        case debug
        
        var displayName: String {
            
            switch self {
                    
                case .countdowns:
                    return "Countdowns"
                case .events:
                    return "Events"
                case .calendars:
                    return "Calendars"
                case .widget:
                    return "Home Screen Widget"
                case .complication:
                    return "Watch Complication"
                case .siri:
                    return "Siri Shortcut"
                case .debug:
                    return "Debug"
                
            }
            
        }
        
        var imageName: String {
            
            switch self {
                
                case .countdowns:
                    return "hourglass"
                case .events:
                    return "calendar.day.timeline.trailing"
                case .calendars:
                    return "checklist"
                case .widget:
                    return "apps.iphone"
                case .complication:
                    return "applewatch.watchface"
                case .siri:
                    return "mic.fill"
                case .debug:
                    return "hammer.fill"
            }
            
        }
        
        var iconForeground: UIColor {
            
            switch self {
            case .countdowns:
                return .white
            case .events:
                return .white
            case .calendars:
                return .white
            case .widget:
                return .systemOrange
            case .complication:
                return .systemOrange
            case .siri:
                return .systemOrange
            case .debug:
                return .white
            }
            
        }
        
        var iconBackground: UIColor {
            
            switch self {
            case .countdowns:
                return .systemOrange
            case .events:
                return .systemOrange
            case .calendars:
                return .systemOrange
            case .widget:
                return .white
            case .complication:
                return .white
            case .siri:
                return .white
            case .debug:
                return .systemBlue
            }
            
        }
        
        func asCellConfig() -> IconButtonTableViewCell.Configuration {
            
            return IconButtonTableViewCell.Configuration(name: self.displayName, imageName: self.imageName, imageColor: self.iconForeground, iconBackground: self.iconBackground)
            
        }
        
       
    }
    
}
