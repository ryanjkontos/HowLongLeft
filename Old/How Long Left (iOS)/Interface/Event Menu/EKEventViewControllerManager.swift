//
//  EKEventViewControllerManager.swift
//  How Long Left (iOS)
//
//  Created by Ryan Kontos on 20/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import UIKit
import EventKit
import EventKitUI

class EKEventViewControllerManager: NSObject, EKEventEditViewDelegate {
    
    static var shared = EKEventViewControllerManager()
    
    func presentEventViewControllerFor(_ event: EKEvent) {
        
        let controller = EKEventEditViewController()
        controller.event = event
        controller.eventStore = HLLEventSource.shared.eventStore
        controller.editViewDelegate = self
        if #available(iOS 13.0, *) {
            controller.isModalInPresentation = true
        }
        DispatchQueue.main.async {
        RootViewController.shared?.present(controller, animated: true, completion: nil)
        }
        
    }

    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        
        DispatchQueue.main.async {
        RootViewController.shared?.dismiss(animated: true, completion: nil)
        }
        
        DispatchQueue.main.async {
            HLLEventSource.shared.updateEventPool()
        }
        
    }
    
}
