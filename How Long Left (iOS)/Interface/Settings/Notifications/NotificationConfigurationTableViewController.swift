//
//  NotificationConfigurationTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 10/11/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import UIKit

class NotificationConfigurationTableViewController: UITableViewController, NotificationAccessDelegate {

    var timeRemaining = [Int]()
    var percentage = [Int]()
    
    var sections = [NotificationTriggerTypeSection]()
    var allTriggers = [HLLNotificationTrigger]()
    
    var scheduler = EventNotificationScheduler()
    
    var history = [HLLNotificationTrigger]()

    var masterCell: SwitchCell?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.becomeFirstResponder()
        self.navigationItem.title = "Notifications"
        
        //let notificationCenter = NotificationCenter.default
       // notificationCenter.addObserver(self, selector: #selector(update), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        EventNotificationScheduler.shared.delegates.append(self)
        
        loadTriggers()
        tableView.register(UINib(nibName: "TitleDetailCell", bundle: nil), forCellReuseIdentifier: "TitleDetailCell")
        tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
        
    }
  
    override func viewDidAppear(_ animated: Bool) {
        
        presentNoAccessAlert()
            
    }
    
    @objc func update() {
        self.loadTriggers()
        self.tableView.reloadData()
    }
    
    func loadTriggers() {
        
        let previousTriggers = self.allTriggers
        
        var loadedSections = [NotificationTriggerTypeSection]()
        
        var timeRemainingTriggers = [HLLNotificationTrigger]()
        
        for triggerSeconds in HLLDefaults.notifications.milestones.sorted(by: { $0 < $1 }) {
            
            let trigger = TimeRemainingNotificationTrigger(seconds: triggerSeconds)
            timeRemainingTriggers.append(trigger)
            
        }
        
        loadedSections.append(NotificationTriggerTypeSection(type: .TimeRemaining, header: "Time Remaining Triggers:", triggers: timeRemainingTriggers))
        
        var percentageTriggers = [HLLNotificationTrigger]()
        
        for triggerPercentage in HLLDefaults.notifications.Percentagemilestones.sorted(by: { $0 < $1 }) {
            
            let trigger = PercentageNotificationTrigger(percentage: triggerPercentage)
            percentageTriggers.append(trigger)
            
        }
        
        loadedSections.append(NotificationTriggerTypeSection(type: .Percentage, header: "Percentage Complete Triggers:", triggers: percentageTriggers))
        
        var statusTriggers = [HLLNotificationTrigger]()
        
        if HLLDefaults.notifications.startNotifications {
            
            let trigger = EventStatusNotificationTrigger(eventStatusTrigger: .Starts)
            statusTriggers.append(trigger)
            
        }
        
        if HLLDefaults.notifications.endNotifications {
            
            let trigger = EventStatusNotificationTrigger(eventStatusTrigger: .Ends)
            statusTriggers.append(trigger)
            
        }
        
        loadedSections.append(NotificationTriggerTypeSection(type: .EventStatus, header: "Event Status Triggers:", triggers: statusTriggers))
        
        
        self.sections = loadedSections
        
        var tempAll = [HLLNotificationTrigger]()
        tempAll.append(contentsOf: timeRemainingTriggers)
        tempAll.append(contentsOf: percentageTriggers)
        tempAll.append(contentsOf: statusTriggers)
        
        self.allTriggers = tempAll
        
        for trigger in previousTriggers {
            
            if self.allTriggers.contains(where: { trigger.value == $0.value && trigger.userString == $0.userString && trigger.type == $0.type }) == false {
                
                history.append(trigger)
                print("Added \(trigger.userString) to history")
                
            }
            
        }
        
        if HLLDefaults.notifications.enabled {
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addTapped))
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        DispatchQueue.main.async {
            
            self.scheduler.scheduleNotificationsForUpcomingEvents()
            HLLDefaultsTransfer.shared.userModifiedPrferences()
        }
        
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if EventNotificationScheduler.shared.hasPermission == false, EventNotificationScheduler.shared.permissionFalseBecauseUnknown == false  {
            return 2
        }
        
        if EventNotificationScheduler.shared.hasPermission == false, EventNotificationScheduler.shared.permissionFalseBecauseUnknown == true  {
            return 1
        }
        
        if HLLDefaults.notifications.enabled == false {
            return 1
        }
        
        if allTriggers.isEmpty {
            return sections.count+1
        } else {
            return sections.count+2
        }
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        if section == 1, EventNotificationScheduler.shared.hasPermission == false {
            return 1
        }
        
        if section == sections.count+1 {
            return 1
        }
        
        var addCount = 1
        if sections[section-1].type == .EventStatus {
            
            if HLLDefaults.notifications.startNotifications, HLLDefaults.notifications.endNotifications {
                addCount = 0
            }
            
        }
        
        return sections[section-1].triggers.count+addCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("Getting cell for row at section: \(indexPath.section), and row: \(indexPath.row)")
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.label = "Send Notifications"
            
            if !EventNotificationScheduler.shared.hasPermission {
                
                cell.valueSwitch.setOn(false, animated: false)
                cell.valueSwitch.isEnabled = false
                
            } else {
            
            cell.valueSwitch.isEnabled = true
            cell.getAction = { return HLLDefaults.notifications.enabled }
            cell.setAction = { value in
                
                HLLDefaults.notifications.enabled = value
                EventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                    self.loadTriggers()
                    self.tableView.reloadData()
                }
                
            }
            
            }
    
            self.masterCell = cell
            return cell
            
        }
        
        if indexPath.section == 1, EventNotificationScheduler.shared.hasPermission == false {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell", for: indexPath) as! TitleDetailCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
            cell.title = "Open Settings..."
            
            if #available(iOS 13.0, *) {
                cell.titleLabel.textColor = .label
            } else {
                cell.titleLabel.textColor = .black
            }
            
            return cell
            
        }

        
        if indexPath.section == sections.count+1 {
            
           let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell", for: indexPath) as! TitleDetailCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
            cell.title = "Delete All Triggers"
            
            if #available(iOS 13.0, *) {
                cell.titleLabel.textColor = .systemRed
            } else {
                cell.titleLabel.textColor = .systemRed
            }
            
            return cell
            
        }
        
        //print("Ind = \(sections[indexPath.section-1].triggers.count)")
        
        if indexPath.row == sections[indexPath.section-1].triggers.count {
            
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell", for: indexPath) as! TitleDetailCell
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
            
            cell.title = "Add Trigger"
            if #available(iOS 13.0, *) {
                cell.titleLabel.textColor = .secondaryLabel
            } else {
                cell.titleLabel.textColor = .lightGray
            }
            
            return cell
            
            
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleDetailCell", for: indexPath) as! TitleDetailCell
        
        cell.accessoryType = .disclosureIndicator
        
        if HLLDefaults.notifications.enabled == true {
            
            cell.selectionStyle = .default
            cell.selectionHandler = {}
            
            if #available(iOS 13.0, *) {
                cell.titleLabel.textColor = .label
            } else {
                cell.titleLabel.textColor = .black
            }
            
        } else {
            
            cell.selectionStyle = .none
            cell.selectionHandler = nil
            
            if #available(iOS 13.0, *) {
                cell.titleLabel.textColor = .secondaryLabel
            } else {
                cell.titleLabel.textColor = .lightGray
            }
            
        }
        
        cell.title = sections[indexPath.section-1].triggers[indexPath.row].userString
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return nil
        }
        
        if section == sections.count+1 {
            return nil
        }
        
        if EventNotificationScheduler.shared.hasPermission {
        
        return self.sections[section-1].header
            
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            
            if EventNotificationScheduler.shared.hasPermission || EventNotificationScheduler.shared.permissionFalseBecauseUnknown {
                return "When enabled, notifications for your events will be sent based on the triggers below."
            } else {
                return "Notifications are not avaliable because How Long Left does not have permission to send them."
            }
            
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1, EventNotificationScheduler.shared.hasPermission == false {
            
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    })
                }
            }
            
            return
            
        }
        
        if HLLDefaults.notifications.enabled {
        
        if indexPath.section == 0 {
            return
        }
            
        if indexPath.section == sections.count+1 {
            presentDeleteAllConfirmation()
            return
        }
        
        DispatchQueue.main.async {
        
            if indexPath.row == self.sections[indexPath.section-1].triggers.count {
                
                let type = self.sections[indexPath.section-1].type
                
                switch type {
                    
                case .TimeRemaining:
                    self.presentTextBox(for: .TimeRemaining)
                case .Percentage:
                    self.presentTextBox(for: .Percentage)
                case .EventStatus:
                    self.presentEventStatusSelectAlert()

                }
                
                return
            }
            
            let trigger = self.sections[indexPath.section-1].triggers[indexPath.row]
        
        if trigger.type == .EventStatus {
            self.presentDeleteConfirmation(for: trigger)
        } else if let value = trigger.value {
            self.presentTextBox(for: trigger.type, value: value)
        }
            
        }
            
        }
        
    }
    
    func presentDeleteConfirmation(for trigger: HLLNotificationTrigger) {
        
        DispatchQueue.main.async {
        
        let alertController = UIAlertController(title: "Do you want to delete this event status trigger?", message: nil, preferredStyle: .alert)
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in

            trigger.removeTriggerAction()
            
            self.loadTriggers()
            self.tableView.reloadData()
            
        }
        alertController.addAction(confirmAction)
        
            self.present(alertController, animated: true, completion: nil)
        
        }
        
    }
    
    func presentDeleteAllConfirmation() {
        
        DispatchQueue.main.async {
        
        let alertController = UIAlertController(title: "Are you sure you want to delete all your notification triggers?", message: nil, preferredStyle: .alert)
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { _ in

            HLLDefaults.notifications.milestones.removeAll()
            HLLDefaults.notifications.Percentagemilestones.removeAll()
            HLLDefaults.notifications.startNotifications = false
            HLLDefaults.notifications.endNotifications = false
            
            self.loadTriggers()
            self.tableView.reloadData()
            
        }
        alertController.addAction(confirmAction)
        
            self.present(alertController, animated: true, completion: nil)
        
        }
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 {
            return false
        }
        
        if indexPath.section == 1, EventNotificationScheduler.shared.hasPermission == false {
            return false
        }
        
        if indexPath.section == sections.count+1 {
            return false
        }
        
        if indexPath.row == self.sections[indexPath.section-1].triggers.count {
            return false
        }
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let oldSections = self.sections
            let newCount = oldSections[indexPath.section-1].triggers.count-1
            
            print("Newcount: \(newCount)")
            
            oldSections[indexPath.section-1].triggers[indexPath.row].removeTriggerAction()
            
            loadTriggers()
            tableView.reloadData()
            
            
        }
    }
    
    @objc func addTapped() {
        
        var style = UIAlertController.Style.actionSheet
        #if targetEnvironment(macCatalyst)
        style = .alert
        #endif
        
        if UIDevice.current.userInterfaceIdiom == .pad {
           style = .alert
        }
        
        let actionSheet = UIAlertController(title: "New Notification Trigger", message: nil, preferredStyle: style)
        
        let timeRemainingTrigger = UIAlertAction(title: "Minutes Remaining", style: .default, handler: { _ in
            
            self.presentTextBox(for: .TimeRemaining)
        
        })
        
        actionSheet.addAction(timeRemainingTrigger)
        
        let percentageCompleteTrigger = UIAlertAction(title: "Percentage Complete", style: .default, handler: { _ in
            
            self.presentTextBox(for: .Percentage)
            
        })
        
        actionSheet.addAction(percentageCompleteTrigger)
        
        if HLLDefaults.notifications.startNotifications == false || HLLDefaults.notifications.endNotifications == false {
           
            let statusTrigger = UIAlertAction(title: "Event Status", style: .default, handler: { _ in
                
                self.presentEventStatusSelectAlert()
                
            })
            actionSheet.addAction(statusTrigger)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func presentTextBox(for type: HLLNotificationTriggerType, value: Int? = nil) {
        
        var message = "Send a notification when an event has the following number of minutes remaining:"
        var placeholder = "Minutes Remaining"
        if type == .Percentage {
            message = "Send a notification when an event is the following percentage complete:"
            placeholder = "Percent Done"
        }
        
        var title = "Add Trigger"
        if value != nil {
            title = "Edit Trigger"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.keyboardType = .numberPad
            textField.textAlignment = .center
            textField.delegate = self
            
            if let text = value {
                
                var number = text
                if type == .TimeRemaining {
                    number = number/60
                }
                
                textField.text = String(number)
            }
            
        }
        
        
        let confirmAction = UIAlertAction(title: "Done", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            
            if let safeValue = value {
                
                switch type {
                                   
                case .TimeRemaining:
                    HLLDefaults.notifications.milestones.removeAll(where: { $0 == safeValue })
                case .Percentage:
                    HLLDefaults.notifications.Percentagemilestones.removeAll(where: { $0 == safeValue })
                case .EventStatus:
                    break
                }

            }
            
            if let fieldText = textField.text, let enteredInt = Int(fieldText) {
                
                switch type {
                    
                case .TimeRemaining:
                    
                    if HLLDefaults.notifications.milestones.contains(enteredInt*60) {
                        
                        self.presentAlert(title: "Invalid Time Remaining", subtitle: "You already have a trigger with this value.")
                        return
                        
                    }
                    
                    if enteredInt == 0 {
                        
                        self.presentAlert(title: "Invalid Time Remaining", subtitle: "Instead of adding a time remaining trigger for 0 minutes, try adding an event status trigger for when an event ends.")
                        return
                        
                    }
                    
                    if enteredInt < 0 {
                        
                        self.presentAlert(title: "Invalid Time Remaining", subtitle: "You can't add time remaining triggers for negative numbers.")
                        return
                        
                    }
                    
                case .Percentage:
                    
                    if HLLDefaults.notifications.Percentagemilestones.contains(enteredInt) {
                        
                        self.presentAlert(title: "Invalid Percentage", subtitle: "You already have a trigger with this value.")
                        return
                        
                    }
                    
                    if enteredInt < 0 {
                        
                        self.presentAlert(title: "Invalid Percentage", subtitle: "You can't add percentage complete triggers for negative numbers.")
                        return
                        
                    }
                    
                    if enteredInt == 0 {
                            
                        self.presentAlert(title: "Invalid Percentage", subtitle: "Instead of adding a percentage complete trigger for when an event is 0% complete, try adding an event status trigger for when an event starts.")
                        return

                    }
                    
                    if enteredInt == 100 {
                            
                        self.presentAlert(title: "Invalid Percentage", subtitle: "Instead of adding a percentage complete trigger for when an event is 100% complete, try adding an event status trigger for when an event ends.")
                        return

                    }
                    
                    if enteredInt > 100 {
                        
                        self.presentAlert(title: "Invalid Percentage", subtitle: "You can't create percentage complete triggers over 100%.")
                        return
                        
                    }
                    
                case .EventStatus:
                    break

                }
                
                if value != enteredInt {
                
                switch type {
                    
                case .TimeRemaining:
                    HLLDefaults.notifications.milestones.append(Int(textField.text!)!*60)
                case .Percentage:
                    HLLDefaults.notifications.Percentagemilestones.append(Int(textField.text!)!)
                case .EventStatus:
                    break
                }
                
                
                self.loadTriggers()
                self.tableView.reloadData()
                    
                }
                
            }
            
        }
        
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
            
        
        if value != nil {
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak alertController] _ in
                guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
                
                switch type {
                    
                case .TimeRemaining:
                    HLLDefaults.notifications.milestones.removeAll(where: { $0 == Int(textField.text!)!*60 })
                case .Percentage:
                    HLLDefaults.notifications.Percentagemilestones.removeAll(where: { $0 == Int(textField.text!)! })
                case .EventStatus:
                    break
                }
                
                self.loadTriggers()
                self.tableView.reloadData()
                
            }
            
            alertController.addAction(deleteAction)
            
        }
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func presentAlert(title: String?, subtitle: String?) {
        
        DispatchQueue.main.async {
        
        let actionSheet = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
         
        
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        actionSheet.addAction(dismissAction)
         
         self.present(actionSheet, animated: true, completion: nil)
            
        }
        
    }
    
    func presentEventStatusSelectAlert() {
        
        var style = UIAlertController.Style.actionSheet
               #if targetEnvironment(macCatalyst)
               style = .alert
               #endif
               
               if UIDevice.current.userInterfaceIdiom == .pad {
                  style = .alert
               }
        
        let actionSheet = UIAlertController(title: "Add Event Status Notification", message: "Select a trigger", preferredStyle: style)
        
        if HLLDefaults.notifications.startNotifications == false {
        
        let start = UIAlertAction(title: "Event Start", style: .default, handler: { _ in
            
            HLLDefaults.notifications.startNotifications = true
            self.loadTriggers()
            self.tableView.reloadData()
            
        })
            
        actionSheet.addAction(start)
            
        }
        
        if HLLDefaults.notifications.endNotifications == false {
        
        let end = UIAlertAction(title: "Event End", style: .default, handler: { _ in
            
            HLLDefaults.notifications.endNotifications = true
            self.loadTriggers()
            self.tableView.reloadData()
            
        })
            
            actionSheet.addAction(end)
            
        }
       
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func presentNoAccessAlert() {
        
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            
            if settings.authorizationStatus == .denied {
                
                DispatchQueue.main.async {
                
                let alertController = UIAlertController(title: "How Long Left does not have permission to send you notifications", message: "Would you like to open settings to fix this?", preferredStyle: .alert)
                
                let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                    
                    if let url = URL(string:UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                            })
                        }
                    }

                 
                }
                
                let action2 = UIAlertAction(title: "Not Now", style: .cancel) { (action:UIAlertAction) in
                 
                    
                }
                
                alertController.addAction(action1)
                alertController.addAction(action2)
                alertController.view.tintColor = UIColor.HLLOrange
                self.present(alertController, animated: true, completion: nil)
                
                }
            }
            
            
        })
        
        
        
        
    }
    
    func notificationAccessState(_ state: Bool) {
        
        DispatchQueue.main.async {

                self.loadTriggers()
                self.tableView.reloadData()
   
        }
        
    }
    

}

extension NotificationConfigurationTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        // Handle backspace/delete
        guard !string.isEmpty else {

            // Backspace detected, allow text change, no need to process the text any further
            return true
        }

        // Input Validation
        // Prevent invalid character input, if keyboard is numberpad
        if textField.keyboardType == .numberPad {

            // Check for invalid input characters
            if CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) {

                // Present alert so the user knows what went wrong

                // Invalid characters detected, disallow text change
                return true
            }
        }
        
        // Allow text change
        return false
    }

    
}

@available(iOS 13.0, *)
extension NotificationConfigurationTableViewController {
    
    func generateDeleteTriggerContextMenuFor(for trigger: HLLNotificationTrigger) -> UIMenu? {

        var actions = [UIAction]()
        
        if trigger.type != .EventStatus {
        
        let editAction = UIAction(title: "Edit Trigger", image: UIImage(systemName: "pencil"), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { _ in
            
            DispatchQueue.main.async {
                
                if trigger.type == .EventStatus {
                           self.presentDeleteConfirmation(for: trigger)
                       } else if let value = trigger.value {
                           self.presentTextBox(for: trigger.type, value: value)
                       }
                
            }
            

        })
        
        actions.append(editAction)
            
        }
        
        let action = UIAction(title: "Delete Trigger", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil, state: .off, handler: { _ in
            
            trigger.removeTriggerAction()

        })
        
        action.attributes = .destructive
        actions.append(action)
        
        if actions.isEmpty == false {
            return UIMenu(title: "", children: actions)
        } else {
            return nil
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        if indexPath.section == 0 {
            return nil
        }
        
        if indexPath.section == 1, EventNotificationScheduler.shared.hasPermission == false {
            return nil
        }
        
        if indexPath.section == sections.count+1 {
            return nil
        }
        
        if indexPath.row == self.sections[indexPath.section-1].triggers.count {
            return nil
        }
        
        let trigger = sections[indexPath.section-1].triggers[indexPath.row]
            
            return UIContextMenuConfiguration(identifier: nil,
                                              previewProvider: nil,
                                            actionProvider: { _ in
                                                
                                                return self.generateDeleteTriggerContextMenuFor(for: trigger)
            })
            
        
        
    }
    
    override func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.loadTriggers()
            self.tableView.reloadData()
        }
        
        return nil
        
    }

    
}
