//
//  MagdaleneSettingsInterfaceController.swift
//  How Long Left (watchOS) Extension
//
//  Created by Ryan Kontos on 17/10/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import WatchKit
import Foundation



class MagdaleneSettingsInterfaceController: WKInterfaceController, DefaultsTransferObserver {
    
    @IBOutlet weak var magdaleneModeSwitch: WKInterfaceSwitch!
    @IBOutlet weak var addLunchAndRecessSwitch: WKInterfaceSwitch!
    @IBOutlet weak var showTermsSwitch: WKInterfaceSwitch!
    @IBOutlet weak var showSchoolHolidaysSwitch: WKInterfaceSwitch!
    @IBOutlet weak var showSportAsStudySwitch: WKInterfaceSwitch!
    @IBOutlet weak var breaksAndHomeroomSwitch: WKInterfaceSwitch!
    @IBOutlet weak var showSubjectNamesSwitch: WKInterfaceSwitch!
    @IBOutlet weak var indicateTimetableChangesSwitch: WKInterfaceSwitch!
    
    override func awake(withContext context: Any?) {
        HLLDefaultsTransfer.shared.addTransferObserver(self)
    }
    
    override func willActivate() {
        setup()
        super.willActivate()
    }
    
 
    
    func setup() {
        magdaleneModeSwitch.setOn(!HLLDefaults.magdalene.manuallyDisabled)
        addLunchAndRecessSwitch.setOn(HLLDefaults.magdalene.showBreaks)
        showTermsSwitch.setOn(HLLDefaults.magdalene.doTerm)
        showSchoolHolidaysSwitch.setOn(HLLDefaults.magdalene.doHolidays)
        showSportAsStudySwitch.setOn(HLLDefaults.magdalene.showSportAsStudy)
        breaksAndHomeroomSwitch.setOn(HLLDefaults.magdalene.hideExtras)
        
        showSubjectNamesSwitch.setOn(HLLDefaults.magdalene.useSubjectNames)
        
        indicateTimetableChangesSwitch.setOn(HLLDefaults.magdalene.showChanges)
        
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
   
    
    
    @IBAction func magdaleneModeSwitched(_ value: Bool) {
        
        HLLDefaults.magdalene.manuallyDisabled = !value
        update()
        
    }
    
    @IBAction func addBreaksSwitched(_ value: Bool) {
        
        HLLDefaults.magdalene.showBreaks = value
        update()
        
    }
    
    @IBAction func showTermsSwitched(_ value: Bool) {
        
        HLLDefaults.magdalene.doTerm = value
        update()
        
    }
    
    @IBAction func showSchoolHolidaysSwitched(_ value: Bool) {
        
        HLLDefaults.magdalene.doHolidays = value
        update()
        
    }
    
    @IBAction func showStudyAsSportSwitched(_ value: Bool) {
        
        HLLDefaults.magdalene.showSportAsStudy = value
        update()
        
    }
    
    
    @IBAction func hideBreaksAndHomeroomSwitched(_ value: Bool) {
        
        HLLDefaults.magdalene.hideExtras = value
        update()
        
    }
    
    @IBAction func indicateChangesClicked(_ value: Bool) {
        
        HLLDefaults.magdalene.showChanges = value
        update()
        
    }
    
    @IBAction func showSubjectNamesClicked(_ value: Bool) {
        
        HLLDefaults.magdalene.useSubjectNames = value
        update()
        
    }
    
    
    
    func update() {
        
        HLLDefaultsTransfer.shared.userModifiedPrferences()
            
        
        
    }
    
    func defaultsUpdated() {
        DispatchQueue.global(qos: .default).async {
            self.setup()
        }
    }
    
    

}
