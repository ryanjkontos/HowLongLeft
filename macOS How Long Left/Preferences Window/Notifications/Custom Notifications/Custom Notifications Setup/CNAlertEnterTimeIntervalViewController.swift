//
//  CNAlertEnterTimeIntervalViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 8/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa

class CNAlertEnterTimeIntervalViewController: NSViewController, NSTextFieldDelegate {

    let addHandler = HLLNTriggerAddHandler()
    var host: CNSessionHandler!
    var timeIntervalType: CNTimeIntervalTriggerType!
    
    var initialValue: Int?
    
    var isDuplicating = false
    
    @IBOutlet weak var titleLabel: NSTextField!
    
    @IBOutlet weak var hourTextField: NSTextField!
    @IBOutlet weak var minutesTextField: NSTextField!
    @IBOutlet weak var secondsTextField: NSTextField!
    
    @IBOutlet weak var hoursStepper: NSStepper!
    @IBOutlet weak var minutesStepper: NSStepper!
    @IBOutlet weak var secondsStepper: NSStepper!
    
    @IBOutlet weak var intervalLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in [hourTextField, minutesTextField, secondsTextField] {
        
            textField!.formatter = OnlyIntegerValueFormatter()
            textField!.delegate = self
            
            
        }
        
        updateIntervalLabel()
        
    }
    
    override func viewWillAppear() {
        performEditorSetup()
    }
    
    override func viewDidAppear() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.minutesTextField.selectText(self)
        }
        self.view.window?.styleMask.remove(.resizable)
        self.view.window?.makeFirstResponder(nil)
        
        
    }
    
    func setup(type: CNTimeIntervalTriggerType, initialValue: Int? = nil) {
        
        self.timeIntervalType = type
        self.initialValue = initialValue
        
    }
    
    func enterEditMode(for trigger: HLLNTrigger) {
        
        switch trigger.type {
            
        case .timeInterval(.timeRemaining):
            setup(type: .timeRemaining, initialValue: trigger.value)
        case .timeInterval(.timeUntil):
            setup(type: .timeUntil, initialValue: trigger.value)
        case .percentageComplete:
            break
        }
        
    }
    
    func performEditorSetup() {
        
        titleLabel.stringValue = getTitleString(for: self.timeIntervalType, editMode: self.initialValue != nil)
           
           if let value = initialValue {
               
               let hours = (value / 3600)
               let minutes = (value % 3600) / 60
               let seconds = (value % 3600) % 60
               
               hourTextField.stringValue = String(hours)
               minutesTextField.stringValue = String(minutes)
               secondsTextField.stringValue = String(seconds)
           }
           
           updateIntervalLabel()
        
    }
    
    func getTitleString(for type: CNTimeIntervalTriggerType, editMode: Bool) -> String {
        
        if editMode, !isDuplicating {
            
            switch type {
                
            case .timeUntil:
                return "Edit Time Until Trigger"
            case .timeRemaining:
                return "Edit Time Remaining Trigger"
            }
            
        } else {
            
            switch type {
                
            case .timeUntil:
                return "Create a new Time Until Trigger"
            case .timeRemaining:
                return "Create a new Time Remaining Trigger"
            }
            
        }
        
    }
    
    func updateIntervalLabel() {
        
        let interval = getCurrentInterval()
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        let formattedString = formatter.string(from: interval)!
        
        switch timeIntervalType! {
    
        case .timeUntil:
            intervalLabel.stringValue = "Sends a notification when there's \(formattedString) until an event starts."
        case .timeRemaining:
            intervalLabel.stringValue = "Sends a notification when an event has \(formattedString) remaining."
        }
        
        
        
        
    }
    
    func controlTextDidChange(_ obj: Notification) {
        
        updateIntervalLabel()
        
    }
    
    func getCurrentInterval() -> TimeInterval {
        
        var intervalString = ""
        
        for (index, textField) in [hourTextField, minutesTextField, secondsTextField].enumerated() {
            
            if textField!.stringValue.isEmpty {
                intervalString += "00"
            } else {
                intervalString += textField!.stringValue
            }
            
            if index != 2 {
                intervalString += ":"
            }
            
        }
        
        var interval: Double = 0
        let parts = intervalString.components(separatedBy: ":")
        
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }
               
        return interval
        
    }
    
    @IBAction func stepperClicked(_ sender: NSStepper) {
        
        var textField = hourTextField
        
        if sender == minutesStepper {
            textField = minutesTextField
        }
        
        if sender == secondsStepper {
            textField = secondsTextField
        }
        
        var newValue = 0
        var currentValue = 0
        currentValue = Int(textField!.stringValue)!
        newValue = currentValue
        
            if sender.integerValue == 1 {
                newValue = currentValue + 1
            } else if sender.integerValue == 0, currentValue > 0 {
                newValue = currentValue - 1
            }
            
            sender.integerValue = 0
            textField?.stringValue = String(newValue)
            updateIntervalLabel()
     
    }
    
    
    override func mouseDown(with event: NSEvent) {
        
        self.view.window?.makeFirstResponder(nil)
        
    }
    
    @IBAction func cancelClicked(_ sender: NSButton) {
        
        self.dismiss(nil)
        
    }
    
    @IBAction func okClicked(_ sender: NSButton) {
        
        // print("Ok clicked")
        
        submit()
        
        
    }
    
    func submit() {
        
        let interval = getCurrentInterval()
                   
        let request = HLLNNewTriggerRequest(type: .timeInterval(self.timeIntervalType), value: Int(interval))
        if isDuplicating == false {
        request.previousValue = self.initialValue
        }
                   
        do {
                       
            try addHandler.requestTrigger(request)
            host.hostViewController.update()
            host.hostViewController.selectTrigger(from: request)
            self.dismiss(nil)
                       
        } catch {
                       
            if let requestError = error as? HLLNTriggerAddError {
                       
            self.dismiss(nil)
            host.handleError(requestError, returnTo: .timeInterval(.timeRemaining))
                           
            }
                       
        }
                   
        
    }
    
    
}

 class OnlyIntegerValueFormatter: NumberFormatter {

    override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {

        // Ability to reset your field (otherwise you can't delete the content)
        // You can check if the field is empty later
        if partialString.isEmpty {
            return true
        }
        
        if partialString.count > 5 {
            return false
        }

        // Optional: limit input length
        /*
        if partialString.characters.count>3 {
            return false
        }
        */

        // Actual check
        return Int(partialString) != nil
    }
}
