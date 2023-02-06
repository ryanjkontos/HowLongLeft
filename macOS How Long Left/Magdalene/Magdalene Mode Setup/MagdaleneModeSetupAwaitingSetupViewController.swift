//
//  MagdaleneModeSetupAwaitingSetupViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 20/1/20.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa
/*
class MagdaleneModeSetupAwaitingSetupViewController: NSViewController {
    
    let schoolEventDownloadNeededEvaluator = SchoolEventDownloadNeededEvaluator()
    
    var parentController: ControllableTabView!
    @IBOutlet weak var spinner: NSProgressIndicator!
    
    var timer: Timer?
    
    override func viewWillAppear() {
        
        self.timer = Timer(timeInterval: 1.0, target: self, selector: #selector(checkMagdaleneMode), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
        
        //self.parentController = (self.parent as! ControllableTabView)
        
        spinner.startAnimation(nil)
        
    }
    
    @objc func checkMagdaleneMode() {
        
        DispatchQueue.global(qos: .default).async {
        
            if self.isTimetableInstalled() {
                
                DispatchQueue.main.async {
                
                // print("Magdalene Mode!")
                self.timer?.invalidate()
                self.timer = nil
                (self.parent as! ControllableTabView).nextPage()
                    
                }
                
            }
            
        }
        
    }
    
    func isTimetableInstalled() -> Bool {
        
        // print("Checking Magdalene mode")
        HLLEventSource.shared.updateEvents()
        
        return SchoolAnalyser.privSchoolMode == .Magdalene && self.schoolEventDownloadNeededEvaluator.evaluateSchoolEventDownloadNeeded() == .notNeeded
        
    }
    
    
    override func viewWillDisappear() {
        
        timer?.invalidate()
        timer = nil
        
    }
    
    @IBAction func openCompassClicked(_ sender: NSButton) {
        
        if let url = URL(string: "https://mchsdow-nsw.compass.education/Communicate/ManageCalendars.aspx") {
            NSWorkspace.shared.open(url)
            
        }
        
        
    }
    
    
    @IBAction func helpClicked(_ sender: NSButton) {
        
        let alert: NSAlert = NSAlert()
            alert.window.title = "How Long Left"
            alert.messageText = "Timetable Download Instructions"
        alert.informativeText = """
        
        To download your timetable, first go to the Compass website and log in by clicking the orange button.
        
        Once you're logged in, open the "Tools" menu by hovering your mouse over the gear icon next to your name in the top right corner of the window. From this menu, click "Sync My Schedule".
        
        Make sure your Private Schedule is enabled in top right section of the "Calendar Synchronisation" page. Once it is, refresh the page and scroll down. Click the link in the green box, then click allow. The Calendar app should open. Once it does, click subscribe.
        
        In the following prompt that appears, set a name for the calendar that will contain your timetable, and set an Auto-refresh frequency. It is important that you choose a frequency that will allow changes to your timetable, like room changes, to be downloaded often. Choosing "Every hour" to "Every 5 minutes" is reccomended.
        
        Once you're done, click OK and wait for How Long Left to continue.
        
        """
        
            alert.alertStyle = NSAlert.Style.informational
            
            
            alert.addButton(withTitle: "Done")
            alert.window.collectionBehavior = .canJoinAllSpaces
            alert.window.level = .floating
            
        alert.runModal()
            
        
    }
    
 
}
*/
