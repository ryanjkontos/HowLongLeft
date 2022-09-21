//
//  MilestoneSettingsTableViewController.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 7/2/19.
//  Copyright © 2019 Ryan Kontos. All rights reserved.
//

import UIKit
import UserNotifications

class MilestoneSettingsTableViewController: UITableViewController {
    
    let scheduler = MilestoneNotificationScheduler()
    let defaults = HLLDefaults.defaults
    var setMilestones = [HLLMilestone]()
    
    static let defaultMilestones = [HLLMilestone(value: 600, isPercent: false), HLLMilestone(value: 300, isPercent: false), HLLMilestone(value: 60, isPercent: false), HLLMilestone(value: 0, isPercent: false)]
    
    static let percentDefaultMilestones = [HLLMilestone(value: 25, isPercent: true), HLLMilestone(value: 50, isPercent: true), HLLMilestone(value: 75, isPercent: true)]
    
    var selectAllState = true
    
    override func viewDidLoad() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        
        super.viewDidLoad()
        
        for milestone in HLLDefaults.notifications.milestones {
            
            setMilestones.append(HLLMilestone(value: milestone, isPercent: false))
            
        }
        
        
        for pMilestone in HLLDefaults.notifications.Percentagemilestones {
            
            
            setMilestones.append(HLLMilestone(value: pMilestone, isPercent: true))
            
        }
        
        self.clearsSelectionOnViewWillAppear = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            
            let center = UNUserNotificationCenter.current()
            // Request permission to display alerts and play sounds.
            
            center.requestAuthorization(options: [.alert, .sound, .badge])
            { (granted, error) in
                
                if granted == false {
                    
                    self.NotoAccessDenied()
                    
                    
                }
            }
            
            
            
        })
        
    }
    
    @objc func addTapped() {
        
        
        
    }
    
    
    @objc func selectAllButtonTapped() {
        
        if #available(iOS 10.0, *) {
            let lightImpactFeedbackGenerator = UISelectionFeedbackGenerator()
            lightImpactFeedbackGenerator.prepare()
            lightImpactFeedbackGenerator.selectionChanged()
            
        }
        
        setMilestones.removeAll()
        
        if selectAllState == true {
            
            for milestone in MilestoneSettingsTableViewController.defaultMilestones {
                
                setMilestones.append(milestone)
                
            }
            
            for pMilestone in MilestoneSettingsTableViewController.percentDefaultMilestones {
                
                setMilestones.append(pMilestone)
                
            }
            
        }
        
        setMilestonesArrayToDefaults()
        tableView.reloadData()
        
    }
    
    
    func setMilestonesArrayToDefaults() {
        
        HLLDefaults.notifications.milestones = [Int]()
        HLLDefaults.notifications.Percentagemilestones = [Int]()
        
        var mArray = [Int]()
        var pArray = [Int]()
        
        for milestone in setMilestones {
            
            if milestone.isPercent == true {
                
                pArray.append(milestone.value)
                
            } else {
                
                mArray.append(milestone.value)
                
            }
            
            
        }
        
        HLLDefaults.notifications.milestones = mArray
        HLLDefaults.notifications.Percentagemilestones = pArray
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        if UIApplication.shared.backgroundRefreshStatus != .available, section == 1 {
            
           return "Background app refresh is currently disabled. You will not receive these countdown notifications until you enable it in Settings."
            
        } else if ProcessInfo.processInfo.isLowPowerModeEnabled == true, section == 1 {
            
            return "Countdown notifications may be unreliable or outdated in Low Power Mode."
            
        }
        
        return nil
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
        return "Send a notification when an event"
        } else {
        return nil
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        if setMilestones.count == MilestoneSettingsTableViewController.defaultMilestones.count+MilestoneSettingsTableViewController.percentDefaultMilestones.count {
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Deselect all", style: .plain, target: self, action: #selector (selectAllButtonTapped))
            selectAllState = false
            
            
        } else {
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Select all", style: .plain, target: self, action: #selector (selectAllButtonTapped))
            selectAllState = true
            
        }
        
        DispatchQueue.main.async {
        
            self.scheduler.scheduleNotificationsForUpcomingEvents()
            
        }
        //  
        
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0 {
            
            return MilestoneSettingsTableViewController.defaultMilestones.count
            
        } else {
            
            return MilestoneSettingsTableViewController.percentDefaultMilestones.count
            
        }
            
           
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var milestone: HLLMilestone
        
        if indexPath.section == 0 {
          milestone = MilestoneSettingsTableViewController.defaultMilestones[indexPath.row]
        } else {
            
            milestone = MilestoneSettingsTableViewController.percentDefaultMilestones[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MilestoneItemCell", for: indexPath) as! MilestoneSettingsCell
        cell.setupCell(milestone: milestone)
        
        if setMilestones.contains(milestone) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print("\(calendars[indexPath.row].title) selected")
        
        if #available(iOS 10.0, *) {
            let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            lightImpactFeedbackGenerator.prepare()
            lightImpactFeedbackGenerator.impactOccurred()
            
        }
        
        var selectedMilestone: HLLMilestone
        
        if indexPath.section == 0 {
          selectedMilestone = MilestoneSettingsTableViewController.defaultMilestones[indexPath.row]
        } else {
            
            selectedMilestone = MilestoneSettingsTableViewController.percentDefaultMilestones[indexPath.row]
        }
        
        
        if setMilestones.contains(selectedMilestone) {
            
            if let index = setMilestones.firstIndex(of: selectedMilestone) {
                
                setMilestones.remove(at: index)
                
            }
            
            
        } else {
            
            setMilestones.append(selectedMilestone)
            
        }
        
        setMilestonesArrayToDefaults()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
            
            tableView.reloadData()
            
        })
        
        
        
    }
    
    func NotoAccessDenied() {
        let alertController = UIAlertController(title: "How Long Left does not have permission to send you notifications", message: "You can grant it in Settings.", preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction) in
            if let url = URL(string:UIApplication.openSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    })
                }
            }
        }
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            print("You've pressed cancel");
        }
        
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.view.tintColor = UIColor.HLLOrange
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}

class HLLMilestone: Equatable {
    
    static func == (lhs: HLLMilestone, rhs: HLLMilestone) -> Bool {
        return lhs.value == rhs.value && lhs.isPercent == rhs.isPercent
    }
    
    let value: Int
    let isPercent: Bool
    
    let settingsRowString: String
    
    init(value inputValue: Int, isPercent inputIsPercent: Bool) {
        value = inputValue
        isPercent = inputIsPercent
        
        
        if isPercent == true {
            
            settingsRowString = "Is \(value)% Complete"
            
        } else {
            
            if value == 0 {
                
                settingsRowString = "Finishes"
                
            } else {
                
                var minText = "minutes"
                if value == 60 {
                    
                    minText = "minute"
                    
                }
                
                settingsRowString = "Has \(value/60) \(minText) left"
                
            }
            
        }
        
    }
    
    
}
