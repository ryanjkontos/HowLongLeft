//
//  RNUIIntroViewController.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 9/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation


import Cocoa

class RNUIIntroViewController: NSViewController {
    
    var parentController: ControllableTabView!
    
    override func viewDidLoad() {
        
        parentController = (self.parent as! ControllableTabView)
        
    }
    
    @IBAction func neverClicked(_ sender: NSButton) {
        
        HLLDefaults.rename.promptToRename = false
        close()
        
    }
    
    @IBAction func notNowClicked(_ sender: NSButton) {
        
        close()
        
    }
    
    func close() {
        
        self.view.window?.performClose(nil)
    }
    
    @IBAction func continueClicked(_ sender: NSButton) {
        
        parentController.nextPage()
        
    }
    
    
}
