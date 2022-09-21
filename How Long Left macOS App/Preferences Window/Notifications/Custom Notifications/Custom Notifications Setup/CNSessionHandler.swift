//
//  CNAlertHost.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 8/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class CNSessionHandler {
    
    let alertsStoryboard = NSStoryboard(name: "CustomNotificationsAlerts", bundle: nil)
    var hostViewController: CustomNotificationPreferencesViewController
    
    init(hostViewController: CustomNotificationPreferencesViewController) {
        self.hostViewController = hostViewController
    }
    
    func newTrigger() {
        
        let selectTypeView = self.alertsStoryboard.instantiateController(withIdentifier: "SelectType") as! CNAlertSelectTypeViewController
        selectTypeView.host = self
        hostViewController.presentAsSheet(selectTypeView)
        
    }

    func createNewTrigger(of type: HLLNTriggerType) {
        
        switch type {
        
        case .timeInterval(.timeRemaining):
            
            let selectTypeView = self.alertsStoryboard.instantiateController(withIdentifier: "EnterTimeInterval") as! CNAlertEnterTimeIntervalViewController
             selectTypeView.host = self
            selectTypeView.setup(type: .timeRemaining)
            hostViewController.presentAsSheet(selectTypeView)
            
        case .timeInterval(.timeUntil):
            
           let selectTypeView = self.alertsStoryboard.instantiateController(withIdentifier: "EnterTimeInterval") as! CNAlertEnterTimeIntervalViewController
           selectTypeView.host = self
           selectTypeView.setup(type: .timeUntil)
           hostViewController.presentAsSheet(selectTypeView)
           
            
        case .percentageComplete:
            
            let selectTypeView = self.alertsStoryboard.instantiateController(withIdentifier: "EnterPercentage") as! CNAlertEnterPercentageViewController
            selectTypeView.host = self
            hostViewController.presentAsSheet(selectTypeView)
            
        }
        
    }
    
    func editTrigger(_ trigger: HLLNTrigger, duplicateMode: Bool = false) {
        
        switch trigger.type {
            
        case .timeInterval(_):
            
            let selectTypeView = self.alertsStoryboard.instantiateController(withIdentifier: "EnterTimeInterval") as! CNAlertEnterTimeIntervalViewController
            selectTypeView.host = self
            selectTypeView.isDuplicating = duplicateMode
            selectTypeView.enterEditMode(for: trigger)
            hostViewController.presentAsSheet(selectTypeView)
            
        case .percentageComplete:
            
            let selectTypeView = self.alertsStoryboard.instantiateController(withIdentifier: "EnterPercentage") as! CNAlertEnterPercentageViewController
            selectTypeView.host = self
            selectTypeView.enterEditMode(for: trigger)
            selectTypeView.isDuplicating = duplicateMode
            hostViewController.presentAsSheet(selectTypeView)
            
        }
    
    }
    
    func handleError(_ error: HLLNTriggerAddError, returnTo: HLLNTriggerType) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
        
        let alert = NSAlert()
        alert.messageText = error.errorTitle
        alert.informativeText = error.errorReason
        alert.beginSheetModal(for: self.hostViewController.view.window!, completionHandler: nil)
            
        }
        
        
        
    }

    
}
