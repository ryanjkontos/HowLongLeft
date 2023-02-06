//
//  NotificationPreferencesViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 9/12/18.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import AppKit
import Preferences


final class NotificationPreferenceViewController: NSViewController, PreferencePane {
    
    let preferencePaneIdentifier = Preferences.PaneIdentifier.notifications
    var preferencePaneTitle: String = "Notifications"
    
    let toolbarItemIcon = PreferencesGlobals.notificationsImage
    
    override var nibName: NSNib.Name? {
        return "NotificationPreferencesView"
}
    @IBOutlet weak var soundsButton: NSButton!
    
    @IBOutlet weak var hotKeyOptionButton_Off: NSButton!
    @IBOutlet weak var hotKeyOptionButton_OptionW: NSButton!
    @IBOutlet weak var hotKeyOptionButton_CommandT: NSButton!
    
    @IBOutlet weak var milestoneOptionButton_10: NSButton!
    @IBOutlet weak var milestoneOptionButton_5: NSButton!
    @IBOutlet weak var milestoneOptionButton_1: NSButton!
    @IBOutlet weak var milestoneOptionButton_Ends: NSButton!
    @IBOutlet weak var milestoneOptionButton_Starts: NSButton!
    
    @IBOutlet weak var percentageMIlestoneOptionButton_25: NSButton!
    @IBOutlet weak var percentageMilestoneOptionButton_50: NSButton!
    @IBOutlet weak var percentageMilestoneOptionButton_75: NSButton!
    
   
    var windowC: NSWindowController?
    
    override func viewDidLoad() {
        self.preferredContentSize = CGSize(width: 529, height: 360)
    }
    
    override func viewWillAppear() {
            
        PreferencesWindowManager.shared.currentIdentifier = preferencePaneIdentifier
            
        let milestones = HLLNTriggerFetcher.shared.getTimeRemainingTriggers()
        let percentageMilestones = HLLNTriggerFetcher.shared.getPercentageTriggers()
        
      //  // print(milestones)
        
        if milestones.contains(600) {
            
            if milestoneOptionButton_10.state == .off {
                milestoneOptionButton_10.setNextState()
            }
            
        } else {
            
            if milestoneOptionButton_10.state == .on {
                milestoneOptionButton_10.setNextState()
            }
            
        }
        
        if milestones.contains(300) {
            
            if milestoneOptionButton_5.state == .off {
                milestoneOptionButton_5.setNextState()
            }
            
        } else {
            
            if milestoneOptionButton_5.state == .on {
                milestoneOptionButton_5.setNextState()
            }
            
        }
        
        if milestones.contains(60) {
            
            if milestoneOptionButton_1.state == .off {
                milestoneOptionButton_1.setNextState()
            }
            
        } else {
            
            if milestoneOptionButton_1.state == .on {
                milestoneOptionButton_1.setNextState()
            }
            
        }
        
        if HLLDefaults.notifications.endNotifications {
            
            if milestoneOptionButton_Ends.state == .off {
                milestoneOptionButton_Ends.setNextState()
            }
            
        } else {
            
            if milestoneOptionButton_Ends.state == .on {
                milestoneOptionButton_Ends.setNextState()
            }
            
        }
        
        if percentageMilestones.contains(25) {
            
            if percentageMIlestoneOptionButton_25.state == .off {
                percentageMIlestoneOptionButton_25.setNextState()
            }
            
        } else {
            
            if percentageMIlestoneOptionButton_25.state == .on {
                percentageMIlestoneOptionButton_25.setNextState()
            }
            
        }
        
        if percentageMilestones.contains(50) {
            
            if percentageMilestoneOptionButton_50.state == .off {
                percentageMilestoneOptionButton_50.setNextState()
            }
            
        } else {
            
            if percentageMilestoneOptionButton_50.state == .on {
                percentageMilestoneOptionButton_50.setNextState()
            }
            
        }

        if percentageMilestones.contains(75) {
            
            if percentageMilestoneOptionButton_75.state == .off {
                percentageMilestoneOptionButton_75.setNextState()
            }
            
        } else {
            
            if percentageMilestoneOptionButton_75.state == .on {
                percentageMilestoneOptionButton_75.setNextState()
            }
            
        }

        if HLLDefaults.notifications.sounds == true {
            
            if soundsButton.state == .off {
                soundsButton.setNextState()
            }
            
        } else {
            
            if soundsButton.state == .on {
                soundsButton.setNextState()
            }
            
        }
        
        if HLLDefaults.notifications.startNotifications == true {
            
            if milestoneOptionButton_Starts.state == .off {
                milestoneOptionButton_Starts.setNextState()
            }
            
        } else {
            
            if milestoneOptionButton_Starts.state == .on {
                milestoneOptionButton_Starts.setNextState()
            }
            
        }
        
        
        
        switch HLLDefaults.notifications.hotkey {
            
        case .Off:
            hotKeyOptionButton_Off.setNextState()
        case .OptionW:
            hotKeyOptionButton_OptionW.setNextState()
        case .CommandT:
            hotKeyOptionButton_CommandT.setNextState()
        }
        
        
    }
    
    
    @IBAction func startsClicked(_ sender: NSButton) {
        
        if sender.state == .on {
            
            HLLDefaults.notifications.startNotifications = true
            
        } else {
            
            HLLDefaults.notifications.startNotifications = false
            
        }
        
        MacEventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        
    }
    
    @IBAction func endsClicked(_ sender: NSButton) {
        
        if sender.state == .on {
            
            HLLDefaults.notifications.endNotifications = true
            
        } else {
            
            HLLDefaults.notifications.endNotifications = false
            
        }
        
        MacEventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        
    }
    
    @IBAction func soundsButtonClicked(_ sender: NSButton) {
        
        if sender.state == .on {
            
            HLLDefaults.notifications.sounds = true
            
        } else {
            
            HLLDefaults.notifications.sounds = false
            
        }
        
        MacEventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        
    }
    
    @IBAction func hotKeyChanged(_ sender: NSButton) {
        
        DispatchQueue.main.async {
        
        HLLDefaults.notifications.hotkey = HLLHotKeyOption(rawValue: Int(sender.identifier!.rawValue)!)!
            
            HotKeyHandler.shared.setHotkey(to: HLLDefaults.notifications.hotkey)
            
        }
        
    }
    
    
    @IBAction func milestoneOptionClicked(_ sender: NSButton) {
        
        DispatchQueue.main.async {
        
        var milestoneArray = [Int]()
        var percentageMilestoneArray = [Int]()
        
            if self.milestoneOptionButton_10.state == .on {
            milestoneArray.append(600)
        }
        
            if self.milestoneOptionButton_5.state == .on {
            milestoneArray.append(300)
        }
        
            if self.milestoneOptionButton_1.state == .on {
            milestoneArray.append(60)
        }
        
            
        if self.percentageMIlestoneOptionButton_25.state == .on {
            percentageMilestoneArray.append(25)
        }
        
        if self.percentageMilestoneOptionButton_50.state == .on {
            percentageMilestoneArray.append(50)
        }
            
        if self.percentageMilestoneOptionButton_75.state == .on {
            percentageMilestoneArray.append(75)
        }

        
        HLLDefaults.notifications.milestones = milestoneArray
        HLLDefaults.notifications.Percentagemilestones = percentageMilestoneArray
        
            MacEventNotificationScheduler.shared.scheduleNotificationsForUpcomingEvents()
        
    }
        
        
        
    
    }
    
}
