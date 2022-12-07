//
//  HLLNTriggerAddHandler.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 4/12/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

class HLLNTriggerAddHandler {
    
    func requestTrigger(_ request: HLLNNewTriggerRequest) throws {
        
        // print("Requesting trigger")
        
        var undoRemovePreviousClosure: (() -> Void)?
        var addTriggerClosure: (() -> Void)?
        
        let value = request.value
        var error: HLLNTriggerAddError?
        
        switch request.type {
            
            case .timeInterval(.timeUntil):
        
                if let previousValue = request.previousValue {
                    let previousArray = HLLDefaults.notifications.startsInMilestones
                    HLLDefaults.notifications.startsInMilestones.removeAll { $0 == previousValue}
                    undoRemovePreviousClosure = { HLLDefaults.notifications.startsInMilestones = previousArray }
                }
            
                let errorTitle = "Invalid Value"
                
                if HLLDefaults.notifications.startsInMilestones.contains(value) {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "You already have a time until trigger with this value.")
                }
            
                
                
                if value == 0 {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "Try enabling notifications for when an event starts instead.")
                }
            
                if value < 0 {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "You can't create time until triggers for negative numbers.")
                }
                
                addTriggerClosure = { HLLDefaults.notifications.startsInMilestones.append(value) }
                
            
            case .timeInterval(.timeRemaining):
            
                if let previousValue = request.previousValue {
                    let previousArray = HLLDefaults.notifications.milestones
                    HLLDefaults.notifications.milestones.removeAll { $0 == previousValue}
                    undoRemovePreviousClosure = { HLLDefaults.notifications.milestones = previousArray }
                }
                
                let errorTitle = "Invalid Value"
                
                if HLLDefaults.notifications.milestones.contains(value) {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "You already have a time remaining trigger with this value.")
                }
            
                if value == 0 {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "Try enabling notifications for when an event ends instead.")
                }
            
                if value < 0 {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "You can't create time remaining triggers for negative numbers.")
                }
                
                addTriggerClosure = { HLLDefaults.notifications.milestones.append(value) }
            
            case .percentageComplete:
            
                if let previousValue = request.previousValue {
                    let previousArray = HLLDefaults.notifications.Percentagemilestones
                    HLLDefaults.notifications.Percentagemilestones.removeAll { $0 == previousValue}
                    undoRemovePreviousClosure = { HLLDefaults.notifications.Percentagemilestones = previousArray }
                }
            
                let errorTitle = "Invalid Value"
                
                if HLLDefaults.notifications.Percentagemilestones.contains(value) {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "You already have a percentage trigger with this value.")
                }
            
                if value == 0 {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "Try enabling notifications for when an event starts instead.")
                }
                
                if value == 100 {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "Try enabling notifications for when an event ends instead.")
                }
            
                if value < 0 {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "You can't create percentage triggers for negative numbers.")
                }
                
                if value > 100 {
                    error = HLLNTriggerAddError(errorTitle: errorTitle, errorReason: "You can't creare percentage triggers over 100%.")
                }
                
                addTriggerClosure = { HLLDefaults.notifications.Percentagemilestones.append(value) }
            
        }
        
        if let unwrappedError = error {
            
            undoRemovePreviousClosure?()
            throw unwrappedError
            
        } else {
            
            addTriggerClosure?()
            
        }
        
        
    }
    
    
    
}

