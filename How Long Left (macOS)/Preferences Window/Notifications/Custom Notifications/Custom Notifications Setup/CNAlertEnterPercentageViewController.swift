//
//  CNAlertEnterPercentageViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/4/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation

import Cocoa

class CNAlertEnterPercentageViewController: NSViewController, NSTextFieldDelegate {

    let addHandler = HLLNTriggerAddHandler()
    var host: CNSessionHandler!
    
    var initialValue: Int?
    var isDuplicating = false
    
    @IBOutlet weak var percentTitleLabel: NSTextField!
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var stepper: NSStepper!
    
    @IBOutlet weak var detailLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField!.formatter = OnlyIntegerValueFormatterPercent()
        textField!.delegate = self
            
        updateIntervalLabel()
        
    }
    
    override func viewWillAppear() {
        performEditorSetup()
    }
    
    override func viewDidAppear() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.textField.selectText(self)
        }
        self.view.window?.styleMask.remove(.resizable)
        self.view.window?.makeFirstResponder(nil)
        
        
    }
    
    func setInitialValue(_ value: Int) {
        
        self.initialValue = value
        
    }
    
    func enterEditMode(for trigger: HLLNTrigger) {
        
        setInitialValue(trigger.value)
         
    }
    
    func performEditorSetup() {
        
        percentTitleLabel.stringValue = getTitleString(editMode: self.initialValue != nil)
           
        if let value = initialValue {
            textField.stringValue = String(value)
        }
           
        updateIntervalLabel()
        
    }
    
    func getTitleString(editMode: Bool) -> String {
        
        if editMode, !isDuplicating {
            return "Edit Percentage Trigger"
        } else {
            return "Create a New Percentage Trigger"
        }
 
        
    }
    
    func updateIntervalLabel() {
        
        let percent = self.textField.stringValue
        detailLabel.stringValue = "Sends a notification when an event is \(percent)% complete."
        
        
    }
    
    func controlTextDidChange(_ obj: Notification) {
        
        updateIntervalLabel()
        
    }
    

    @IBAction func percentStepperClicked(_ sender: NSStepper) {
        
        var newValue = 0
        var currentValue = 0
        currentValue = Int(textField.stringValue)!
        newValue = currentValue
              
        print("Int value was \(sender.integerValue)")
              
        if sender.integerValue == 1 {
            newValue = currentValue + 1
        } else if sender.integerValue == 0, currentValue > 0 {
            newValue = currentValue - 1
        }
                  
        sender.integerValue = 0
        textField.stringValue = String(newValue)
        updateIntervalLabel()
        
    }
    
    override func mouseDown(with event: NSEvent) {
        
        self.view.window?.makeFirstResponder(nil)
        
    }
    
    @IBAction func percentCancelClicked(_ sender: NSButton) {
        self.dismiss(nil)
    }
    
    @IBAction func percentDoneClicked(_ sender: NSButton) {
        
        print("Ok clicked")
        submit()
        
    }
    
    func submit() {
        
        var value = 0
        
        if let percent = Int(self.textField.stringValue) {
            value = percent
        }
                   
        let request = HLLNNewTriggerRequest(type: .percentageComplete, value: value)
        if !isDuplicating {
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
            host.handleError(requestError, returnTo: .percentageComplete)
                           
            }
                       
        }
                   
        
    }
    
    
}

 class OnlyIntegerValueFormatterPercent: NumberFormatter {

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
