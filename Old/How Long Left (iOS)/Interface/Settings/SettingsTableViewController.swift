//
//  SettingsTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 10/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, DefaultsTransferObserver, EventPoolUpdateObserver {

    var sections = [[SettingsCell]]()
    var sectionFooters = [String?]()
    
    var preview: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HLLDefaultsTransfer.shared.addTransferObserver(self)
        HLLEventSource.shared.addEventPoolObserver(self)
        
        tableView.register(UINib(nibName: "TitleDetailCell", bundle: nil), forCellReuseIdentifier: "TitleDetailCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadSections()
    }
    
    func reloadSections() {
        
        var tempSections = [[SettingsCell]]()
        var tempSectionFooters = [String?]()

        
        tempSections.append([.General])
        tempSectionFooters.append("Manage general How Long Left preferences")
        
        //#if targetEnvironment(macCatalyst)
        
        //sections.append([.Calendars])
        //ectionFooters.append("Manage the calendars How Long Left uses to display events.")
        
        //#else
        
        tempSections.append([.Calendars, .Notifications])
        tempSectionFooters.append("Manage the calendars How Long Left uses to display events, and the notifications it sends.")
        
        var extensionsSection = [SettingsCell.SiriAndWidget]
        
        if WatchSessionManager.sharedManager.watchSupported() {
        extensionsSection.append(.AppleWatch)
        }
        
        
        tempSections.append(extensionsSection)
        tempSectionFooters.append("Manage How Long Left's extensions.")
        
        //#endif
        
       /* if SchoolAnalyser.privSchoolMode == .Magdalene {
        tempSections.append([.Magdalene])
        tempSectionFooters.append("Manage features specific to Magdalene users.")
        } */
        
        #if DEBUG
        
        tempSections.append([.Debug])
        tempSectionFooters.append(nil)
        
        #endif
        
        sections = tempSections
        sectionFooters = tempSectionFooters
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getCellFor(sections[indexPath.section][indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if let cell = tableView.cellForRow(at: indexPath) as? TitleDetailCell {
            cell.selectionHandler?()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return sectionFooters[section]
        
    }
    
    func getCellFor(_ type: SettingsCell) -> UITableViewCell {
        
        switch type {
            
        case .General:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! TitleDetailCell
            
            cell.title = "General"
            
            cell.selectionHandler = {
                
                if let controller = self.getViewControllerFor(settingsCell: .General) {
                self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }
            
            return cell
            
        case .Calendars:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! TitleDetailCell
            
            cell.title = "Calendars"
            
            let enabledCount = HLLDefaults.calendar.enabledCalendars.count
            let totalCount = HLLEventSource.shared.getCalendars().count
            
            cell.detail = "\(enabledCount)/\(totalCount)"
            
            cell.selectionHandler = {
                
            if let controller = self.getViewControllerFor(settingsCell: .Calendars) {
                self.navigationController?.pushViewController(controller, animated: true)
            }
            
            }
            
            return cell
            
        case .Notifications:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! TitleDetailCell
            
            cell.title = "Notifications"
            
            var count = HLLDefaults.notifications.Percentagemilestones.count + HLLDefaults.notifications.milestones.count
            if HLLDefaults.notifications.startNotifications {
                count += 1
            }
            if HLLDefaults.notifications.endNotifications {
                count += 1
            }
            
            cell.detail = "\(count)"
            
            if HLLDefaults.notifications.enabled == false {
                cell.detail = "Off"
            }
            
            if EventNotificationScheduler.shared.hasPermission == false {
               cell.detail = "Off"
            }
            
            cell.selectionHandler = {
            
                if let controller = self.getViewControllerFor(settingsCell: .Notifications) {
                self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }
            
            return cell
            
        case .Magdalene:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! TitleDetailCell
            
            cell.title = "Magdalene Mode"
            
            cell.selectionHandler = {
                
            if let controller = self.getViewControllerFor(settingsCell: .Magdalene) {
                self.navigationController?.pushViewController(controller, animated: true)
            }
                
            }
            
            var status = "Disabled"
           /* if SchoolAnalyser.schoolMode == .Magdalene {
                status = "Enabled"
            } */
            
            cell.detail = status
            
            return cell
            
        case .SiriAndWidget:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! TitleDetailCell
            
            cell.title = "Siri & Widget"
            
            cell.selectionHandler = {
            
                
                if let controller = self.getViewControllerFor(settingsCell: .SiriAndWidget) {
                self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }
            
            return cell
            
        case .AppleWatch:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! TitleDetailCell
            
            cell.title = "Apple Watch"
            
            cell.selectionHandler = {
            
                if let controller = self.getViewControllerFor(settingsCell: .AppleWatch) {
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }
            
            return cell
        case .Debug:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell") as! TitleDetailCell
            
            cell.title = "Debug"
            
            cell.selectionHandler = {
            
               
                if let controller = self.getViewControllerFor(settingsCell: .Debug) {
                self.navigationController?.pushViewController(controller, animated: true)
                }
                
            }
            
            return cell
            
        }
        
    }
    
    func getViewControllerFor(settingsCell: SettingsCell) -> UIViewController? {
        
        var returnView: UIViewController?
        
        var tableViewType = UITableView.Style.grouped
        if #available(iOS 13.0, *) {
            tableViewType = .insetGrouped
        }

        switch settingsCell {
            
        case .General:
            returnView = GeneralSettingsTableViewController(style: tableViewType)
        case .Calendars:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            returnView = storyboard.instantiateViewController(withIdentifier: "CalendarsView") as! CalendarSelectTableViewController
        case .Notifications:
            returnView = NotificationConfigurationTableViewController(style: tableViewType)
        case .Magdalene:
            break
           // returnView = MagdaleneTableViewController(style: tableViewType)
        case .SiriAndWidget:
            returnView = SiriAndWidgetTableViewController(style: tableViewType)
        case .AppleWatch:
            returnView = AppleWatchSettingsTableViewController(style: tableViewType)
        case .Debug:
            returnView = DebugMenuTableViewController(style: tableViewType)
        }
        
        return returnView
        
    }
    
    
    func defaultsUpdated() {
        reloadSections()
    }
    
    func eventPoolUpdated() {
        reloadSections()
    }
    
    
}

@available(iOS 13.0, *)
extension SettingsTableViewController {
    
    func generateContextMenuFor(_ type: SettingsCell) -> UIMenu? {
        
        var menuTitle = ""
        var actions = [UIAction]()
        
        switch type {
            
        case .General:
            menuTitle = "General"
        case .Calendars:
            
            menuTitle = "Calendars"
            
            var title = "Enable All"
            var imageTitle = "calendar.badge.plus"
            if HLLDefaults.calendar.enabledCalendars.count == HLLEventSource.shared.getCalendars().count {
                title = "Disable All"
                imageTitle = "calendar.badge.minus"
            }
            
            let action = UIAction(title: title, image: UIImage(systemName: imageTitle), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { _ in
                
                CalendarDefaultsModifier.shared.toggleAllCalendars()
                
                HLLEventSource.shared.updateEventPool()

            })
            
            actions.append(action)
            
        case .Notifications:
            
            menuTitle = "Notifications"
            
            var title = "Enable Notifications"
            var imageTitle = "app.badge"
            if HLLDefaults.notifications.enabled {
                title = "Disable Notifications"
                imageTitle = "xmark"
            }
            
            let action = UIAction(title: title, image: UIImage(systemName: imageTitle), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { _ in
                
                HLLDefaults.notifications.enabled = !HLLDefaults.notifications.enabled
                EventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()

            })
            
            actions.append(action)
            
        case .Magdalene:
            
            menuTitle = "Magdalene Mode"
            
            var title = "Disable Magdalene Mode"
            var imageTitle = "xmark.circle"
           /* if HLLDefaults.magdalene.manuallyDisabled {
                title = "Enable Magdalene Mode"
                imageTitle = "checkmark.circle"
            } */
            
            let action = UIAction(title: title, image: UIImage(systemName: imageTitle), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { _ in
                
               // HLLDefaults.magdalene.manuallyDisabled = !HLLDefaults.magdalene.manuallyDisabled
                HLLEventSource.shared.asyncUpdateEventPool()

            })
            
            actions.append(action)
            
            
        case .SiriAndWidget:
            break
        case .AppleWatch:
            break
        case .Debug:
            break
        }
        
        
        if actions.isEmpty == false {
            return UIMenu(title: menuTitle, children: actions)
        } else {
            return nil
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let type = sections[indexPath.section][indexPath.row]
        if let view = getViewControllerFor(settingsCell: type) {
            
            preview = view
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: { return view }, actionProvider: { _ in
                return self.generateContextMenuFor(type)
            })
            
        } else {
            
            return nil
            
        }
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.reloadData()
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        
        animator.addCompletion {
            
            if let safePreview = self.preview {
            
            self.show(safePreview, sender: self)

            }
            
        }
        
    }
    
}
