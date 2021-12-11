//
//  RNUIDoneViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 25/6/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Cocoa
/*
class RNUIDoneViewController: NSViewController {
    @IBOutlet weak var infoLabel: NSTextField!
    
    @IBOutlet weak var automaticallyPromptButton: NSButton!
    var parentController: ControllableTabView!
    @IBOutlet weak var doneAnimationView: AnimationView!
    
    func playDoneAnimation() {
        DispatchQueue.main.async {
        
            self.doneAnimationView.animation = Animation.named("DoneAnimation")!
            self.doneAnimationView.loopMode = .playOnce
            self.doneAnimationView.play()
            
        }
        
    }
    
    override func viewDidLoad() {
        parentController = (self.parent as! ControllableTabView)
        
        
        super.viewDidLoad()
        // Do view setup here.
        
        
    let renamed = HLLDefaults.defaults.integer(forKey: "RenamedEvents")
        let breaks = HLLDefaults.defaults.integer(forKey: "AddedBreaks")
        
        var infoString = "\(renamed) events have been renamed"
        
        if renamed > 0 {
            
            
            
            if breaks > 0 {
                
                infoString = "\(infoString), and \(breaks) have been added."
                
            } else {
                
                infoString = "\(infoString)."
                
            }
            
            
            
        } else {
            
            if breaks > 0 {
                
                infoString = "No events were renamed, but \(breaks) breaks were added."
                
            } else {
                
                infoString = "No changes were made."
                
            }
            
            
        }
        
        DispatchQueue.main.async {
            
            self.infoLabel.stringValue = infoString
            
            if HLLDefaults.rename.promptToRename {
                
                self.automaticallyPromptButton.state = .on
                
            } else {
                
                self.automaticallyPromptButton.state = .off
            }
            
        }
            
        
       playDoneAnimation()
        
        
    }
    
    @IBAction func promptClicked(_ sender: NSButton) {
        
        if sender.state == .on {
            HLLDefaults.rename.promptToRename = true
            
        } else {
            
           HLLDefaults.rename.promptToRename = false
        }
        
        
    }
    
    
    @IBAction func doneClicked(_ sender: NSButton) {
        
        self.view.window?.performClose(nil)
        
      //  MemoryRelaunch().relaunchApp()
        
    }
}
*/
