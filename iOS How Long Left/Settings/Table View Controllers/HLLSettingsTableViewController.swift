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
        
        let eventsSection = [
            RowType.pinned,
            RowType.hidden,
            RowType.nicknames
        ]
        
        let extensionsSection = [
            RowType.widget,
            RowType.complication,
        ]
        
     
        sections = [SettingsSection(mainSection), SettingsSection(eventsSection), SettingsSection(header: "Extensions", extensionsSection)]
        
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactiveDeselect(animated: animated)
        
        
        
        
    }
    
    func interactiveDeselect(animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }) { context in
                    if context.isCancelled {
                        self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
                    }
                }
            } else {
                self.tableView.deselectRow(at: selectedIndexPath, animated: animated)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconButtonCell", for: indexPath) as! IconButtonTableViewCell
        cell.configure(using: sections[indexPath.section].rows[indexPath.row].asCellConfig())
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let type = sections[indexPath.section].rows[indexPath.row]
            
        switch type {
            
        case .countdowns:
            
            let vc = CountdownsSettingsTableViewController(style: .insetGrouped)
            self.navigationController?.pushViewController(vc, animated: true)
            
            
        case .events:
            let vc = EventsSettingsTableViewController(style: .insetGrouped)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .calendars:
            
            let vc = ToggleCalendarsTableViewController(style: .insetGrouped)
            self.navigationController?.pushViewController(vc, animated: true)
            
        case .widget:
            
            let hc = UIHostingController(rootView: ExtensionPurchaseParentView(type: .widget))
            self.present(hc, animated: true)
            self.tableView.deselectRow(at: indexPath, animated: true)
            
        case .complication:
            
            let hc = UIHostingController(rootView: ExtensionPurchaseParentView(type: .complication))
            self.present(hc, animated: true)
            self.tableView.deselectRow(at: indexPath, animated: true)
            
        case .siri:
            break
        case .debug:
            break
        case .hidden:
            let vc = ManageEventsTableViewController(dataSource: HiddenEventsListDataSource())
            self.navigationController?.pushViewController(vc, animated: true)
        case .nicknames:
            let vc = ManageNicknamesTableViewController(style: .insetGrouped)
            self.navigationController?.pushViewController(vc, animated: true)
        case .pinned:
            let vc = ManageEventsTableViewController(dataSource: PinnedEventsListDataSource())
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
        
    
        
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }

    struct SettingsSection {
        
        internal init(header: String? = nil, _ rows: [HLLSettingsTableViewController.RowType] = [RowType]()) {
            self.header = header
            self.rows = rows
        }
        
        
        var header: String?
        var rows = [RowType]()
        
    }
    
    var biggestTopSafeAreaInset: CGFloat = 0
                
        override func viewSafeAreaInsetsDidChange() {
            super.viewSafeAreaInsetsDidChange()
            self.biggestTopSafeAreaInset = max(self.tableView.safeAreaInsets.top, biggestTopSafeAreaInset)
        }

    enum RowType: CaseIterable {
        
        case countdowns
        case events
        case calendars
        
        case widget
        case complication
        case siri
        
        case hidden
        case nicknames
        case pinned
        
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
                
            case .hidden:
                return "Hidden Events"
            case .nicknames:
                return "Nicknames"
            case .pinned:
                return "Pinned Events"
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
                case .hidden:
                    return "eye.slash.fill"
                case .nicknames:
                    return "character.cursor.ibeam"
                case .pinned:
                    return "pin.fill"
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
            case .hidden:
                return .white
            case .nicknames:
                return .white
            case .pinned:
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
                return UIColor(named: "DarkWhite")!
            case .complication:
                return UIColor(named: "DarkWhite")!
            case .siri:
                return UIColor(named: "DarkWhite")!
            case .debug:
                return .systemBlue
            case .hidden:
                return .systemOrange
            case .nicknames:
                return .systemOrange
            case .pinned:
                return .systemOrange
            }
            
        }
        
        func asCellConfig() -> IconButtonTableViewCell.Configuration {
            
            return IconButtonTableViewCell.Configuration(name: self.displayName, imageName: self.imageName, imageColor: self.iconForeground, iconBackground: self.iconBackground)
            
        }
        
       
    }
    
}

extension HLLSettingsTableViewController: ScrollUpDelegate {
    
    
    func scrollUp() {
        
        if let c = self.navigationController?.viewControllers.count, c > 1 {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        let offset = CGPoint(
                x: -tableView.adjustedContentInset.left,
                y: -tableView.adjustedContentInset.top)
        
        tableView.setContentOffset(offset, animated: true)
    }
    
 
}
