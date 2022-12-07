//
//  SettingsMainTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 24/1/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit
import Intents
import IntentsUI
import UserNotifications

class SettingsMainTableViewController: UITableViewController, ScrollUpDelegate, DefaultsTransferObserver {
    
    func defaultsUpdated() {
        tableView.reloadData()
    }
    
    
    static var justPurchasedComplication = false
    var themeableCells = [ThemeableCell]()
    
    let defaults = HLLDefaults.defaults
    var tableSections = [Int:SettingsSection]()
   // let schoolAnalyser = SchoolAnalyser()
    var genedSections: Int {
        
        get {
            
            return tableSections.count
            
            
        }
        
    }
    
    override func viewDidLoad() {
        
        HLLEventSource.shared.updateEvents()
        IAPHandler.shared.fetchAvailableProducts()
        RootViewController.hasFadedIn = true
        HLLDefaultsTransfer.shared.addTransferObserver(self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
        
        DispatchQueue.main.async {
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
        
        }


    
    @objc func appMovedToForeground() {
        
        tableView.reloadData()
        
    }
    
    func generateTableData() {

        tableSections.removeAll()
        
        tableSections[tableSections.count] = SettingsSection.General
        
        #if !targetEnvironment(macCatalyst)
        tableSections[tableSections.count] = SettingsSection.Siri
        #endif
        
        if WatchSessionManager.sharedManager.watchSupported() == true {
        tableSections[tableSections.count] = SettingsSection.Complication
        }
        
        if SchoolAnalyser.privSchoolMode == .Magdalene {
        tableSections[tableSections.count] = SettingsSection.Magdalene
        }
        
        if WatchSessionManager.sharedManager.watchSupported() == true {
            tableSections[tableSections.count] = SettingsSection.Sync
        }
        
        themeableCells.removeAll()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        RootViewController.selectedController = self
        
        tableView.reloadData()
        
        if SettingsMainTableViewController.justPurchasedComplication == true {
            
            SettingsMainTableViewController.justPurchasedComplication = false
            
        }
  
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        let sectionType = tableSections[section]!
        
        if sectionType == SettingsSection.Siri {
            
            return "Check How Long Left with Siri."
            
        }
        
        if sectionType == SettingsSection.Magdalene {
            
            switch SchoolAnalyser.privSchoolMode {
   
            case .Magdalene:
                return "Enable special features for students of Magdalene Catholic College."
            case .None:
                return nil
            case .Unknown:
                return nil
            }
            
        }

        if sectionType == .Complication {
            
            return "Enable to count down current and upcoming events on your watch face."
            
        }
        
        if sectionType == .Sync {
            
            return "Sync How Long Left preferences between your iPhone and Apple Watch."
            
        }

        
        return nil
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        generateTableData()
        
        return tableSections.count
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = tableSections[section]!
        
        switch sectionType {
            
        case .General:
            return 2
        case .Siri:
            return 1
        case .Complication:
            return 1
        case .Magdalene:
            return 1
        case .Sync:
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = tableSections[indexPath.section]!
        let row = indexPath.row
        
        switch sectionType {
        
        case .General:
            
            if row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath) as! MainCalendarsRow
                
                cell.setupCell()
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! MainNotificationsCell
                
                cell.setupCell()
                return cell
                
            }
        
        case .Siri:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SiriCell", for: indexPath)

    
            return cell
            
        case .Complication:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ComplicationCell", for: indexPath) as! MainComplicationCell
      
            cell.setupCell()
            return cell
            
        case .Magdalene:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MagdaleneCell", for: indexPath) as! MainMagdaleneCell

            cell.setupCell()
            return cell
        case .Sync:
            
            tableView.register(UINib(nibName: "SwitchCell", bundle: nil), forCellReuseIdentifier: "SwitchCell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            
            cell.label = "Sync Preferences"
            cell.getAction = { return HLLDefaults.watch.syncPreferences }
            cell.setAction = { value in HLLDefaults.watch.syncPreferences = value
                
                DispatchQueue.global(qos: .default).async {
                    HLLDefaultsTransfer.shared.userModifiedPrferences()
                }
                
            }
            
            return cell
        }
        
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = tableSections[indexPath.section]!
        
        if section == .General {
            
            
            if indexPath.row == 0 {
                
                if HLLEventSource.accessToCalendar == .Granted {
                
                performSegue(withIdentifier: "CalendarsSegue", sender: nil)
                    
                } else {
                    
                    if let url = URL(string:UIApplication.openSettingsURLString) {
                        if UIApplication.shared.canOpenURL(url) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                                })
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                    }

                    
                    tableView.deselectRow(at: indexPath, animated: true)
                    
                }
                
                
            }
            
            if indexPath.row == 1 {
                
                performSegue(withIdentifier: "MilestonesSegue", sender: nil)
                
            }
            
            
            
            
            
        }
        
        if section == SettingsSection.Siri, indexPath.row == 0 {
            
            #if !targetEnvironment(macCatalyst)
            
            if #available(iOS 12.0, *) {
             /*   if let shortcut = INShortcut(intent: HowLongLeftIntent()) {
                    
                    shortcut.intent?.suggestedInvocationPhrase = "How Long Left"
                    
                    if let alreadyRegistedVoiceShortcut = voiceShortcutStore.registeredShortcut {
                        
                         alreadyRegistedVoiceShortcut.shortcut.intent?.suggestedInvocationPhrase = "How Long Left"
                        
                       let viewC = INUIEditVoiceShortcutViewController(voiceShortcut: alreadyRegistedVoiceShortcut)
                        if #available(iOS 13.0, *) {
                            viewC.modalPresentationStyle = .fullScreen
                        } else {
                            viewC.modalPresentationStyle = .formSheet
                        }
                        viewC.delegate = self
                        viewC.view.tintColor = UIColor.HLLOrange
                      //  self.present(viewC, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            
                            self.present(viewC, animated: true, completion: nil)
                            
                        })
                        
                        
                        
                    } else {
                        
                        #if !targetEnvironment(macCatalyst)
                        
                        let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
                        if #available(iOS 13.0, *) {
                            viewController.modalPresentationStyle = .fullScreen
                        } else {
                            viewController.modalPresentationStyle = .formSheet
                        }
                        viewController.delegate = self
                        viewController.view.tintColor = UIColor.HLLOrange
                        viewController.view.backgroundColor = UIColor.black
        
                        
                        
                        // Object conforming to `INUIAddVoiceShortcutViewControllerDelegate`.
                     //   self.present(viewController, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            
                            self.present(viewController, animated: true, completion: nil)
                            
                        })
                        
                        #endif
                        
                    }
                    
                    
                } */
                
                
                
            } else {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    
                    tableView.reloadData()
                    
                })
                
            }
            
            #endif
        }
        
        if section == SettingsSection.Complication {
            
            
            
            if IAPHandler.shared.hasPurchasedComplication() == false {
            
                if IAPHandler.shared.canMakePurchases() == false {
                    
                    presentAlert(title: "In-App Purchases Disabled", message: "In-App Purchases are not allowed on this device.")
                    return
                    
                }
                
                
                if BackgroundFunctions.isReachable == false {
                    
                    presentAlert(title: "No Internet Connection", message: "Connect to the internet to purchase this item.")
                    return
                    
                }
                
                if IAPHandler.complicationPriceString == nil {
                    
                    IAPHandler.shared.fetchAvailableProducts()
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            
                            if IAPHandler.complicationPriceString == nil {
                                
                                self.presentAlert(title: "Error", message: "An error occured communicating with the App Store.")
                                
                            } else {
                                
                                self.presentComplicationPurcahseView()
                                
                            }
                        
                    })
                    
                    
                } else {
                    
                    presentComplicationPurcahseView()
                    
                }
                
                
           
            
            } else {
                
            showComplicationPurchasedAlert(purchasedNow: false)
                
            }
            
        }
        
        
    
}
    
    func presentComplicationPurcahseView() {
        
        let vc = BackgroundFunctions.shared.getPurchaseComplicationViewController()
        
        present(vc, animated: true, completion: nil)
        
        
    }
    
    func presentAlert(title: String, message: String) {
        
        DispatchQueue.main.async {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action1)
        alertController.view.tintColor = UIColor.HLLOrange
            self.present(alertController, animated: true, completion: nil)
        
        
        
        }
    }
    
    func showComplicationPurchasedAlert(purchasedNow: Bool) {
        
        var message = "You may need to launch How Long Left on your watch to trigger changes."
        var titleText = "You've purchased the Apple Watch Complication"
        
        if purchasedNow {
            
            titleText = "Purchase Successful!"
            
        } else {
            
            if SchoolAnalyser.privSchoolMode == .Magdalene {
                
                titleText = "Apple Watch Complication is enabled"
                message = "As a Magdalene user, you have access to the complication for free."
                
            }
            
        }
        
        let alertController = UIAlertController(title: titleText, message: message, preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action1)
        alertController.view.tintColor = UIColor.HLLOrange
        DispatchQueue.main.async {
        self.present(alertController, animated: true, completion: nil)
        }
        
        
    }


    let waitToDismiss = 0.25
    
    func scrollUp() {
        if self.tableView.numberOfSections != 0, self.tableView.numberOfRows(inSection: 0) > 0 {
            
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            
        }
    }
    
}

@available(iOS 12.0, *)
extension SettingsMainTableViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        VoiceShortcutStatusChecker.shared.check()
        VoiceShortcutStatusChecker.shared.check()
        DispatchQueue.main.asyncAfter(deadline: .now() + waitToDismiss, execute: {
            controller.dismiss(animated: true, completion: nil)
        })
        
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        VoiceShortcutStatusChecker.shared.check()
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}

@available(iOS 12.0, *)
extension SettingsMainTableViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        VoiceShortcutStatusChecker.shared.check()
        DispatchQueue.main.asyncAfter(deadline:.now() + waitToDismiss, execute: {
            controller.dismiss(animated: true, completion: nil)
        })
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        VoiceShortcutStatusChecker.shared.check()
        DispatchQueue.main.asyncAfter(deadline: .now() + waitToDismiss
            , execute: {
            controller.dismiss(animated: true, completion: nil)
        })
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}


@available(iOS 12.0, *)
class voiceShortcutStore {
    static var registeredShortcut: INVoiceShortcut?
}

class MainCalendarsRow: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func setupCell() {
        
  
        if HLLEventSource.accessToCalendar == .Granted {
        
            if HLLDefaults.calendar.enabledCalendars.count > 0 {
            
                let enabledCount = HLLDefaults.calendar.enabledCalendars.count
                let totalCount = HLLEventSource.shared.getCalendars().count
                
            countLabel.text = "\(enabledCount)/\(totalCount)"
            
            if enabledCount < 1 {
                
                countLabel.textColor = UIColor.red
                
            } else {
                
                countLabel.textColor = #colorLiteral(red: 0.5556007624, green: 0.5556976795, blue: 0.5753890276, alpha: 1)
                
            }
            
        }
        } else {
            
            countLabel.text = "No Access"
            countLabel.textColor = UIColor.red
            
        }
        
    }
    
 
}

class MainNotificationsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    func setupCell() {
        
        
        if UIApplication.shared.backgroundRefreshStatus != .available {
            
            statusLabel.text = "Unavaliable"
            
        } else if HLLDefaults.notifications.milestones.isEmpty == false || HLLDefaults.notifications.Percentagemilestones.isEmpty == false {
            
            // Request permission to display alerts and play sounds.
            
            self.statusLabel.text = "\(HLLDefaults.notifications.milestones.count+HLLDefaults.notifications.Percentagemilestones.count) Enabled"
            self.statusLabel.textColor = #colorLiteral(red: 0.5556007624, green: 0.5556976795, blue: 0.5753890276, alpha: 1)
            
            
        } else {
            
            statusLabel.text = "Off"
            statusLabel.textColor = #colorLiteral(red: 0.5556007624, green: 0.5556976795, blue: 0.5753890276, alpha: 1)
            
        }
        
        
        
        
    }
    

    
}

class MainComplicationCell: UITableViewCell, ThemeableCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var statusTextCell: UILabel!
    
    func setupCell() {
        
        if IAPHandler.shared.hasPurchasedComplication() == true {
            
            if SchoolAnalyser.privSchoolMode != .Magdalene {
                self.statusTextCell.text = "Purchased"
            } else {
                self.statusTextCell.text = "Enabled"
            }
            
        } else {
            
            if let priceString = IAPHandler.complicationPriceString {
                
                statusTextCell.text = priceString
                
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.gotPrice), name: Notification.Name("gotComplicationPrice"), object: nil)
        
       
        
       // complicationFakeSwitch.setOn(IAPHandler.shared.hasPurchasedComplication(), animated: false)
        
        
    }
    
   @objc func gotPrice() {
    
    DispatchQueue.main.async {
    
    if IAPHandler.shared.hasPurchasedComplication() == false {
        
        if let priceString = IAPHandler.complicationPriceString {
            
            
            
            self.statusTextCell.text = priceString
                
                
            
        } else {
            
            self.statusTextCell.text = nil
            
        }
        
    } else {
        
        if SchoolAnalyser.privSchoolMode != .Magdalene {
            self.statusTextCell.text = "Purchased"
        } else {
            self.statusTextCell.text = "Enabled"
        }
        
    }
    
    }
        
    }
    
   
    
    func updateTheme(animated: Bool) {
        

        
    }

    
  /*  @IBAction func complicationSwitchChanged(_ sender: UISwitch) {
        IAPHandler.shared.setPurchasedStatus(sender.isOn)
        
        DefaultsSync.shared.syncDefaultsToWatch()
        
    }
    */
    
    
}

class MainMagdaleneCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    
    func setupCell() {
        
        if SchoolAnalyser.schoolMode == .Magdalene {
            statusLabel.text = "On"
            
        } else {
            statusLabel.text = "Off"
        }
       
        titleLabel.text = "Magdalene Mode"
          
        
    }
    
}

class CloudSyncCell: UITableViewCell {
    
    @IBOutlet weak var syncSwitch: UISwitch!
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        
        HLLDefaults.defaults.set(!sender.isOn, forKey: "DisabledCloudSync")
        
    }
    
    func setupCell() {
        
        syncSwitch.isOn = !HLLDefaults.defaults.bool(forKey: "DisabledCloudSync")
        
    }
    
}

enum SettingsSection: String {
    
    case General = "General"
    case Siri = "Siri"
    case Complication = "Complication"
    case Magdalene = "Magdalene"
    case Sync = "Sync"
    
}

protocol ThemeChangedDelegate {
    func themeChanged()
}

protocol ThemeableCell {
    func updateTheme(animated: Bool)
}
